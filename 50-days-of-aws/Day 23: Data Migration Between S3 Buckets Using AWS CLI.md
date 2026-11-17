# Day 23

As part of a data migration project, the team lead has tasked the team with migrating data from an existing S3 bucket to a new S3 bucket. The existing bucket contains a substantial amount of data that must be accurately transferred to the new bucket. The team is responsible for creating the new S3 bucket and ensuring that all data from the existing bucket is copied or synced to the new bucket completely and accurately. It is imperative to perform thorough verification steps to confirm that all data has been successfully transferred to the new bucket without any loss or corruption.

As a member of the Nautilus DevOps Team, your task is to perform the following:

Create a New Private S3 Bucket: Name the bucket datacenter-sync-433507618.

Data Migration: Migrate the entire data from the existing datacenter-s3-433507618 bucket to the new datacenter-sync-433507618 bucket.

Ensure Data Consistency: Ensure that both buckets have the same data.

Use AWS CLI: Use the AWS CLI to perform the creation and data migration tasks.


aws s3api create-bucket --bucket datacenter-sync-433507618 --region us-east-1
{
    "Location": "/datacenter-sync-433507618",
    "BucketArn": "arn:aws:s3:::datacenter-sync-433507618"
}

aws s3 ls datacenter-s3-433507618

aws s3 cp s3://amazon-s3-demo-source-bucket/ \
    s3://amazon-s3-demo-destination-bucket/ \
    --recursive --source-region SOURCE-REGION-NAME --region DESTINATION-REGION-NAME

aws s3 cp s3://datacenter-s3-433507618/ \
    s3://datacenter-sync-433507618/ \
    --recursive --source-region us-east-1 --region us-east-1


aws s3 ls datacenter-sync-433507618
                           PRE wp-admin/
                           PRE wp-content/
                           PRE wp-includes/
2026-11-17 20:30:16        405 index.php
2026-11-17 20:30:16      19903 license.txt
2026-11-17 20:30:16       7407 readme.html
2026-11-17 20:30:16       7718 wp-activate.php
2026-11-17 20:30:27        351 wp-blog-header.php
2026-11-17 20:30:27       2323 wp-comments-post.php
2026-11-17 20:30:27       3339 wp-config-sample.php
2026-11-17 20:30:35       5617 wp-cron.php
2026-11-17 20:31:23       2493 wp-links-opml.php
2026-11-17 20:31:23       3937 wp-load.php
2026-11-17 20:31:23      52536 wp-login.php
2026-11-17 20:31:23       8727 wp-mail.php
2026-11-17 20:31:23      33152 wp-settings.php
2026-11-17 20:31:23      35093 wp-signup.php
2026-11-17 20:31:23       5396 wp-trackback.php
2026-11-17 20:31:23       3205 xmlrpc.php

