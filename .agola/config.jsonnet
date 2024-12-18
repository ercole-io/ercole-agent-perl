local task_pkg_build(setup) = {
  name: 'pkg build ' + setup.dist,
  runtime: {
    type: 'pod',
    arch: 'amd64',
    containers: [
      { image: 'fra.ocir.io/fremyxlx6yog/fedora-fpm:0.1' },
    ],
  },
  working_dir: '/project',
  environment: {
    WORKSPACE: '/project',
    ERCOLE_AGENT_PERL_FILES: 'ercole-agent=/opt/ercole-agent-perl/ercole-agent config=/opt/ercole-agent-perl lib=/opt/ercole-agent-perl marshal=/opt/ercole-agent-perl sql=/opt/ercole-agent-perl logger=/opt/ercole-agent-perl',
    DIST: setup.dist,
    FPM_TARGET: setup.fpm_target,
    ERCOLE_AGENT_PERL_PACKAGE_SPECIFIC_FILES: setup.package_specific_files
  },
  steps: [
    { type: 'clone' },
    {
      type: 'run',
      name: 'version',
      command: |||
        if [ -z ${AGOLA_GIT_TAG} ] || [[ ${AGOLA_GIT_TAG} == *-* ]]; then 
          export VERSION=latest
        else
          export VERSION=${AGOLA_GIT_TAG}
        fi
        echo VERSION: ${VERSION}
        echo "export VERSION=${VERSION}" > /tmp/variables
      |||,
    },
    {
      type: 'run',
      name: 'sed version',
      command: |||
        source /tmp/variables
        sed -i "s|ERCOLE_VERSION|${VERSION}|" ercole-agent
      |||,
    }
  ] + (
      if setup.os != "solaris" then [
          {
              type: 'run',
              name: 'comment lib/URI',
              command: 'sed -i \'/needed only by Solaris/s/use/# use/\' ercole-agent'
          }
      ] else []
  ) + [
    {
      type: 'run',
      name: 'build',
      command: |||
        source /tmp/variables

        if [ $FPM_TARGET == "tar" ]; then export PACKAGE_FILE=ercole-agent-perl-${VERSION}-1.${DIST}.noarch.tar.gz; fi
        if [ $FPM_TARGET == "rpm" ]; then export PACKAGE_FILE=ercole-agent-perl-${VERSION}-1.${DIST}.noarch.rpm; fi
        echo $PACKAGE_FILE

        fpm -p ${PACKAGE_FILE} -n ercole-agent-perl -s dir -t ${FPM_TARGET} -a all --rpm-os ${DIST} \
          --version ${VERSION} --name ercole-agent-perl ${ERCOLE_AGENT_PERL_FILES} ${ERCOLE_AGENT_PERL_PACKAGE_SPECIFIC_FILES}

        ls -latr && mkdir dist && mv ${PACKAGE_FILE} ./dist/
      |||,
    },
    { type: 'save_to_workspace', contents: [{ source_dir: './dist/', dest_dir: '/dist/', paths: ['**'] }] },
  ],
  depends: ['check perl syntax'],
};

local task_deploy_repository(dist) = {
  name: 'deploy repository.ercole.io ' + dist,
  runtime: {
    type: 'pod',
    arch: 'amd64',
    containers: [
      { image: 'curlimages/curl' },
    ],
  },
  environment: {
    REPO_USER: { from_variable: 'repo-user' },
    REPO_TOKEN: { from_variable: 'repo-token' },
    REPO_UPLOAD_URL: { from_variable: 'repo-upload-url' },
    REPO_INSTALL_URL: { from_variable: 'repo-install-url' },
  },
  steps: [
    { type: 'restore_workspace', dest_dir: '.' },
    {
      type: 'run',
      name: 'curl',
      command: |||
        cd dist
        for f in *; do
        	URL=$(curl --user "${REPO_USER}" \
            --upload-file $f ${REPO_UPLOAD_URL} --insecure)
        	echo $URL
        	md5sum $f
        	curl -H "X-API-Token: ${REPO_TOKEN}" \
          -H "Content-Type: application/json" --request POST --data "{ \"filename\": \"$f\", \"url\": \"$URL\" }" \
          ${REPO_INSTALL_URL} --insecure
        done
      |||,
    },
  ],
  depends: ['pkg build ' + dist],
  when: {
    tag: '#.*#',
    branch: 'master',
  },
};

local task_upload_asset(dist) = {
 name: 'upload to github.com ' + dist,
  runtime: {
    type: 'pod',
    arch: 'amd64',
    containers: [
      { image: 'curlimages/curl' },
    ],
  },
 environment: {
    GITHUB_USER: { from_variable: 'github-user' },
    GITHUB_TOKEN: { from_variable: 'github-token' },
  },
steps: [
    { type: 'restore_workspace', dest_dir: '.' },
    {
      type: 'run',
      name: 'upload to github',
      command: |||
          cd dist
          GH_REPO="https://api.github.com/repos/${GITHUB_USER}/ercole-agent-perl/releases"
          if [ ${AGOLA_GIT_TAG} ];
            then GH_TAGS="$GH_REPO/tags/$AGOLA_GIT_TAG" ;
          else
            GH_TAGS="$GH_REPO/latest" ; fi
          response=$(curl -sH "Authorization: token ${GITHUB_TOKEN}" $GH_TAGS)
          eval $(echo "$response" | grep -m 1 "id.:" | grep -w id | tr : = | tr -cd '[[:alnum:]]=')
          for filename in *; do
            REPO_ASSET="https://uploads.github.com/repos/${GITHUB_USER}/ercole-agent-perl/releases/$id/assets?name=$(basename $filename)"
            curl -H POST -H "Authorization: token ${GITHUB_TOKEN}" -H "Content-Type: application/octet-stream" --data-binary @"$filename" $REPO_ASSET
            echo $REPO_ASSET
          done
      |||,
    },
  ],
  depends: ['pkg build ' + dist],
  when: {
    tag: '#.*#',
    branch: 'master',
  },
};

{
  runs: [
    {
      name: 'ercole-agent-perl',
      tasks: [
        {
          name:'check perl syntax',
          runtime: {
            type: 'pod',
            architecture: 'amd64',
            containers: [ { image: 'fra.ocir.io/fremyxlx6yog/fedora-fpm:0.1' } ],  
          },         
          steps: [
            { type: 'clone' },
            { type: 'run', command: 'perl -c ercole-agent'},
          ],
        }, 
      ] + [
        task_pkg_build(setup)
        for setup in [
          {
             os: 'solaris',
             dist: 'solaris10',
             fpm_target: 'tar',
             package_specific_files: 'fetch/solaris=/opt/ercole-agent-perl/fetch package/solaris10/config.json=/opt/ercole-agent-perl/config.json package/solaris10/ercole-agent-perl-start=/lib/svc/method/ercole-agent-perl-start package/solaris10/ercole-agent-perl.xml=/var/svc/manifest/site/ercole-agent-perl.xml',
          },
          {
             os: 'solaris', 
             dist: 'solaris11', 
             fpm_target: 'tar', 
             package_specific_files: 'fetch/solaris=/opt/ercole-agent-perl/fetch package/solaris11/config.json=/opt/ercole-agent-perl/config.json package/solaris11/ercole-agent-perl-start=/lib/svc/method/ercole-agent-perl-start package/solaris11/ercole-agent-perl.xml=/lib/svc/manifest/site/ercole-agent-perl.xml', 
          },
          {
             os: 'aix', 
             dist: 'aix6.1', 
             fpm_target: 'rpm', 
             package_specific_files: 'fetch/aix=/opt/ercole-agent-perl/fetch package/aix/config.json=/opt/ercole-agent-perl/config.json package/aix/ercole-agent-perl=/etc/rc.d/init.d/ercole-agent-perl'
          },
          {
             os: 'hpux', 
             dist: 'hpux', 
             fpm_target: 'tar', 
             package_specific_files: 'fetch/hpux=/opt/ercole-agent-perl/fetch package/hpux/config.json=/opt/ercole-agent-perl/config.json package/hpux/ercole-agent-perl=/sbin/init.d/ercole-agent-perl',
          },
        ]
      ] + [
          task_deploy_repository(dist)
          for dist in ['solaris10', 'solaris11', 'aix6.1', 'hpux']
      ] + [
        task_upload_asset(dist)
        for dist in ['solaris10', 'solaris11', 'aix6.1', 'hpux']
      ],
    },
  ],
}
