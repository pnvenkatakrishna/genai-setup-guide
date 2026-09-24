# AWS Free Tier & Free Plan – Complete Notes

## Overview

AWS provides a Free Tier program for new users to explore AWS services with free usage limits, trial offers, and promotional credits.

New AWS accounts may receive up to **$200 USD promotional credits**:

- **$100 USD** at signup
- Additional **$100 USD** earned through eligible service exploration activities

These credits are valid for:

- **6 months from account creation**, or
- Until all credits are exhausted

Official AWS Free Tier Page:  
https://aws.amazon.com/free/

---

# Types of AWS Free Offers

AWS Free Tier consists of 3 categories:

| Type | Description |
|---|---|
| Free Trials | Short-term free access to specific services |
| 12-Month Free Tier | Free usage limits available for 12 months after account creation |
| Always Free | Free monthly usage limits available forever on eligible services |

---

# 1. Free Trials

Some AWS services provide temporary free trials.

Examples:
- Amazon Lightsail
- Amazon Redshift
- Amazon OpenSearch Service

These trials may last:
- 7 days
- 30 days
- 60 days
- or based on usage limits

---

# 2. 12-Month Free Tier

Available only for the first 12 months after creating an AWS account.

## Common Examples

| Service | Free Limit |
|---|---|
| Amazon EC2 | 750 hours/month of t2.micro or t3.micro |
| Amazon S3 | 5 GB Standard Storage |
| Amazon RDS | 750 hours/month |
| AWS Lambda | 1 Million requests/month |
| Amazon CloudFront | 1 TB data transfer out |

---

# 3. Always Free Tier

These services remain free every month even after the first year.

## Examples

| Service | Always Free Limit |
|---|---|
| AWS Lambda | 1 Million requests/month |
| Amazon DynamoDB | 25 GB storage |
| AWS CloudWatch | Basic monitoring metrics |
| AWS SNS | 1 Million publishes |
| AWS SQS | 1 Million requests |

Monthly quotas reset every month.

Official FAQ:  
https://aws.amazon.com/free/free-tier-faqs/

---

# Important Billing Information

## AWS Will NOT Charge You If

- Your usage stays within Free Tier limits
- Promotional credits are available
- You do not upgrade to a Paid Plan
- No paid resources are running

---

# AWS May Charge You If

## 1. Free Limits Are Exceeded

Example:
- Running multiple EC2 instances
- Using larger instance types
- Excess S3 storage

---

## 2. Resources Run Continuously

Example:
- EC2 instances left running
- NAT Gateway running
- Load Balancers active

---

## 3. Data Transfer Charges

Inbound traffic is mostly free.

Outbound internet traffic may incur charges.

---

## 4. Elastic IP Charges

Unused Elastic IP addresses may generate charges.

---

## 5. Paid Services Outside Free Tier

Some AWS services are not included in Free Tier.

Examples:
- NAT Gateway
- Dedicated Hosts
- Certain GPU instances

---

# Best Practices to Avoid AWS Charges

## 1. Enable Billing Alerts

Use:
- AWS Billing Dashboard
- AWS Budgets
- CloudWatch Billing Alarms

---

## 2. Stop Unused EC2 Instances

Always stop or terminate unused resources.

---

## 3. Delete Unused Resources

Delete:
- EBS Volumes
- Snapshots
- Load Balancers
- Elastic IPs

---

## 4. Monitor Billing Frequently

Check:
- Billing Dashboard
- Cost Explorer
- Free Tier Usage

---

## 5. Use Only Free Tier Eligible Services

Always verify:
- Region
- Instance Type
- Service Eligibility

---

# Upgrade to Paid Plan

AWS allows upgrading from Free Plan to Paid Plan directly from the AWS Console.

After upgrading:
- Pay-as-you-go pricing applies
- Charges apply based on actual usage

---

# Real-World Example

Suppose you create:
- 1 EC2 t2.micro instance
- 5 GB S3 bucket
- Small Lambda functions

If usage stays within limits:
- Cost = $0

If you:
- Run larger EC2 instances
- Use NAT Gateway
- Store large files in S3

Charges will apply.

---

# Key Interview Points

## What is AWS Free Tier?

AWS Free Tier is a program that allows users to access AWS services for free within specified usage limits.

---

## Difference Between Free Tier and Always Free

| Free Tier | Always Free |
|---|---|
| Valid for limited duration | Available forever |
| Mostly 12 months | Monthly reset |
| New accounts only | Available to all AWS users |

---

## What Happens After Free Tier Ends?

- Services continue running
- Standard AWS pricing applies
- User must monitor billing carefully

---

# Important AWS Links

## AWS Free Tier
https://aws.amazon.com/free/

## AWS Pricing Calculator
https://calculator.aws/

## AWS Billing Dashboard
https://console.aws.amazon.com/billing/

## AWS Free Tier FAQ
https://aws.amazon.com/free/free-tier-faqs/

---

# Final Summary

- AWS offers Free Tier access for learning and experimentation
- New users may receive up to $200 promotional credits
- Free Tier includes:
  - Free Trials
  - 12-Month Free Tier
  - Always Free Services
- Charges occur only when:
  - Free limits are exceeded
  - Paid services are used
  - Resources are left running
- Always monitor billing and clean unused resources