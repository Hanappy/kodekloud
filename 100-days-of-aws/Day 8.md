As part of the migration, there were some components added to the AWS account. Team created one of the EC2 instances where they need to make some changes now.

There is an EC2 instance named datacenter-ec2 under us-east-1 region, enable the stop protection for this instance.



Use below given AWS Credentials: (You can run the showcreds command on aws-client host to retrieve these credentials)

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-stop-protection.html

Console
To enable stop protection for an instance
Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.

In the left navigation pane, choose Instances.

Select the instance, and then choose Actions>Instance settings>Change stop protection.

Select the Enable checkbox, and then choose Save.


CLI
To enable stop protection for an instance
Use the modify-instance-attribute command.


aws ec2 modify-instance-attribute \
    --instance-id i-1234567890abcdef0 \
    --disable-api-stop