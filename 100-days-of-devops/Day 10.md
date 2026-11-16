# Day 10

The production support team of xFusionCorp Industries is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for archiving website content files. They have a static website running on App Server 1 in Stratos Datacenter, and they need to create a bash script named ecommerce_archive.sh which should accomplish the following tasks. (Also remember to place the script under the /scripts directory on App Server 1).



a. Create a zip archive named xfusioncorp_ecommerce.zip of /var/www/html/ecommerce directory.


b. Save the archive in the /archives/ directory on the App Server 1. This is a temporary storage, as archives from this location will be cleaned on a weekly basis. Therefore, the archive should also be copied to the Nautilus Storage Server so it can be retrieved later for validation purposes.


c. Copy the created archive to the Nautilus Storage Server server in the /archives/ location.


d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.

Note:
The zip package must be installed on given App Server before executing the script. This package is essential for creating the zip archive of the website files. Install it manually outside the script.


Solution:

ssh tony@Appserver1 

zip (existed on server)

# Give ownership for used directory

 ls -dl /scripts/ /archives/
sudo chown -R tony:tony /archives/
sudo chown -R tony:tony /scripts/

sudo chown -R natasha:natasha /archives/


# Generate SSH key if not already present (press Enter for default prompts/no passphrase)
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

#  Copy the public key to the Storage Server (enter password once)
ssh-copy-id natasha@ststor01


# Create script file 

cd /script
touch ecommerce_archive.sh
chmod +x ecommerce_archive.sh


# Troubleshoot I had to do. 

I had to redo the exercise time to understand why I could see the xfusioncorp_ecommerce.zip file in archive on the storage server but not the check who returned the following message : 

- 'xfusioncorp_blog.zip' not found under the '/archives' directory on the Storage Server.

In fact the sudo chown -R natasha:natasha /archives/ command on the storage server was necessary for the script to be able to use it because the owner used to be root



