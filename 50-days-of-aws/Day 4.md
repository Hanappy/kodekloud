# Day 4

Data protection and recovery are fundamental aspects of data management. It's essential to have systems in place to ensure that data can be recovered in case of accidental deletion or corruption. The DevOps team has received a requirement for implementing such measures for one of the S3 buckets they are managing.

The s3 bucket name is xfusion-s3-373981002, enable versioning for this bucket.



aws s3api put-bucket-versioning --bucket xfusion-s3-373981002 --versioning-configuration Status=Enabled