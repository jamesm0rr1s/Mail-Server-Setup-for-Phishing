# Mail Server Setup for Phishing (PhishServ)

PhishServ is a penetration testing and red teaming tool that automates the setup of a mail server allowing restricted relaying.

## Installation

Clone the GitHub repository
```
git clone https://github.com/jamesm0rr1s/Mail-Server-Setup-for-Phishing /opt/jamesm0rr1s/Mail-Server-Setup-for-Phishing
```

## Usage

 - Update the domain, email, and IP in "/opt/jamesm0rr1s/Mail-Server-Setup-for-Phishing/createMailServerWithRelay.sh"
 - Create the mail server by running the following commands:
```
chmod +x /opt/jamesm0rr1s/Mail-Server-Setup-for-Phishing/createMailServerWithRelay.sh
/opt/jamesm0rr1s/Mail-Server-Setup-for-Phishing/createMailServerWithRelay.sh
```
