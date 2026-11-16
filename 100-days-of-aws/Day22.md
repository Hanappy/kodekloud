
The Nautilus DevOps team needs to set up a new EC2 instance that can be accessed securely from their landing host (aws-client). The instance should be of type t2.micro and named xfusion-ec2. A new SSH key with name id_rsa should be created on the aws-client host under the/root/.ssh/ folder, if it doesn't already exist. This key should then be added to the root user's authorised keys on the EC2 instance, allowing passwordless SSH access from the aws-client host.



aws ec2 create-key-pair --key-name id_rsa --query 'KeyMaterial' --output text > id_rsa.pem
cat id_rsa.pem >> /root/.ssh/authorized_keys
cat /root/.ssh/authorized_keys


Private key vs. Public key mismatch: aws ec2 create-key-pair outputs the private key (-----BEGIN RSA PRIVATE KEY-----). Appending a private key to authorized_keys will not work—SSH requires the public key (ssh-rsa AAAA...) inside authorized_keys, while the private key stays on aws-client at /root/.ssh/id_rsa.

Wrong host for authorized_keys: Running >> /root/.ssh/authorized_keys on aws-client puts the key on the client machine instead of the target devops-ec2 instance. Additionally, the prompt specifically asks to generate /root/.ssh/id_rsa on aws-client first (if it doesn't already exist) and import it as an AWS key pair named id_rsa.


Second try

The Nautilus DevOps team needs to set up a new EC2 instance that can be accessed securely from their landing host (aws-client). The instance should be of type t2.micro and named devops-ec2. A new SSH key with name id_rsa should be created on the aws-client host under the/root/.ssh/ folder, if it doesn't already exist. This key should then be added to the root user's authorised keys on the EC2 instance, allowing passwordless SSH access from the aws-client host.


[ -f /root/.ssh/id_rsa ] || ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N ""
chmod 600 /root/.ssh/id_rsa

aws ec2 import-key-pair \
  --key-name id_rsa \
  --public-key-material fileb:///root/.ssh/id_rsa.pub


AMI_ID=$(aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023.*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images, &CreationDate)[-1].ImageId" \
  --output text)

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type t2.micro \
  --key-name id_rsa \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=devops-ec2}]' \
  --query "Instances[0].InstanceId" \
  --output text)

aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)


ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa ec2-user@"$PUBLIC_IP" \
  "sudo mkdir -p /root/.ssh && sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys && sudo chmod 700 /root/.ssh && sudo chmod 600 /root/.ssh/authorized_keys && sudo chown -R root:root /root/.ssh"


ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa ec2-user@ec2-100-27-29-46.compute-1.amazonaws.com

sudo cat /root/.ssh/authorized_keys



aws-client ~ ✖ ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa root@ec2-100-27-29-46.compute-1.amazonaws.com
Please login as the user "ec2-user" rather than the user "root".




aws-client ~ ➜  ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa ec2-user@ec2-100-27-29-46.compute-1.amazonaws.com \
  "sudo mkdir -p /root/.ssh && sudo cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/authorized_keys && sudo chown -R root:root /root/.ssh && sudo chmod 700 /root/.ssh && sudo chmod 600 /root/.ssh/authorized_keys"

aws-client ~ ➜  ssh -o BatchMode=yes root@ec2-100-27-29-46.compute-1.amazonaws.com "whoami"
root

