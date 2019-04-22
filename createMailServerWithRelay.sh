#! /bin/bash

# Creates a mail server allowing relaying.

# Set Hosting Records
# Create an A record with the hostname "mail" pointing to IP address of mail.example.com with TTL of 5 minutes
# Create an MX record with the hostname "mail" pointing to "mail.example.com" with TTL of 5 minutes and a Priority of 1

# Install Postfix
installPostfix(){

	# Update package list to pick up new repository's package information
	apt update

	# Set the variables
	fqdn="mail.example.com"
	rootAddress="root@example.com"
	relayFrom="1.2.3.4"

	# Set the Postfix options
	debconf-set-selections <<EOF
postfix postfix/main_mailer_type select Internet Site
postfix postfix/mailname string $fqdn
postfix postfix/root_address string $rootAddress
postfix postfix/destinations string $fqdn
postfix postfix/mynetworks string 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 $relayFrom
postfix postfix/mailbox_limit string 0
postfix postfix/recipient_delim string +
postfix postfix/protocols select ipv4
EOF

	# Install Postfix
	DEBIAN_FRONTEND=noninteractive apt install -y postfix

	# Re-adjust settings later if needed
	# dpkg-reconfigure postfix
	# service postfix reload
}

# Tweak the Postfix Configuration
tweakPostfix(){

	# Configure home_mailbox
	postconf -e 'home_mailbox= Maildir/'

	# Set maps table to map arbitrary email accounts to Linux system accounts. The table is created at /etc/postfix/virtual
	postconf -e 'virtual_alias_maps= hash:/etc/postfix/virtual'
}

# Map the Mail Addresses to Linux Accounts
mapAddresses(){

	# Map contact and admin email addresses to the root account
	echo "contact@example.com root" > /etc/postfix/virtual
	echo "admin@example.com root" >> /etc/postfix/virtual

	# Apply the mapping
	postmap /etc/postfix/virtual

	# Restart the Postfix process to apply the changes
	systemctl restart postfix
}

# Set up the Environment to Match the Mail Location
setupTheEnvironment(){

	# Set the MAIL environment variable in multiple locations
	echo 'export MAIL=~/Maildir' | sudo tee -a /etc/bash.bashrc | sudo tee -a /etc/profile.d/mail.sh

	# Read the variable into the current session
	source /etc/profile.d/mail.sh
}

# Install and Configure the Mail Client
installMailClient(){

	# To interact with the mail being delivered, install the s-nail package
	apt install -y s-nail

	# Adjust settings to allow client to open even with an empty inbox
	echo "set emptystart" >> /etc/s-nail.rc
	echo "set folder=Maildir" >> /etc/s-nail.rc
	echo "set record=+sent" >> /etc/s-nail.rc
}

# Initialize the Maildir and Test the Client
initializeMaildir(){

	# Send an email to create the Maildir structure within the home directory
	echo 'init' | s-nail -s 'init' -Snorecord root
}

installPostfix
tweakPostfix
mapAddresses
setupTheEnvironment
installMailClient
initializeMaildir