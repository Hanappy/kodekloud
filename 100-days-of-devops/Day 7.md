# Day 7

The system admins team of xFusionCorp Industries has set up some scripts on jump host that run on regular intervals and perform operations on all app servers in Stratos Datacenter. To make these scripts work properly we need to make sure the thor user on jump host has password-less SSH access to all app servers through their respective sudo users (i.e tony for app server 1). Based on the requirements, perform the following:



Set up a password-less authentication from user thor on jump host to all app servers through their respective sudo users.


check if there is no key
ls -la ~/.ssh

ssh-keygen -t ed25519 -C "thor@jumphost"

ssh-copy-id tony@stapp01
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03
for each use the password this once

if not ssh-copy-id
cat ~/.ssh/id_rsa.pub | ssh tony@stapp01 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

SSH will reject key authentication if file permissions are too open. 
Ensure the remote environment enforces these modes:

Directory ~/.ssh: permission 700 (drwx------)

File ~/.ssh/authorized_keys: permission 600 (-rw-------)


check ssh tony@stapp01 if it works