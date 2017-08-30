## hardenedDebian

**N.B** *This project is built and tested for Debian 8 (Jessie)*

Script(s) to automate basic hardening steps taken when initally setting up a new Debian Jessie box. These will be as generic as possible, later on I plan to write scripts for bootstraping a web server and Tor relay.  

`harden.sh` Will ask you to add a non-root user, update the system, install hardened SSH configs and install a Cron job to update the box every week.

`/configs` Contains the configuration files to be installed e.g sshd_config & Cron jobs

#### Bug Bounty

If you find a security impacting bug or error in the scripts or configs I wil buy you a Jäger Bomb (or equivalent drink of your choosing). Please [raise an Issue](https://github.com/MikeyJck/hardened-debian/issues/new) if you find or have found a problem that fits the above description.
