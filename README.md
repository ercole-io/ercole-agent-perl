# ercole-agent-perl

Agent for the ERCOLE project

# How to install ercole-agent-perl
1) Install(with the package manager) perl
2) Install(with the package manager) cpan
3) perl -MCPAN -eshell
	3.0) Yes
	3.1) install Bundle::LWP
	3.2) install LWP::Protocol::https
4) Copy the startup script in startup/ercole-agent to /sbin/init.d/ercole-agent

# Various info
The logs are in /var/adm/ercole-agent.log