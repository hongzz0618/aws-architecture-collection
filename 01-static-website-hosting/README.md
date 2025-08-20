# 01 — Static Website Hosting

This example shows how to host a static website on AWS.  
The site is stored in **Amazon S3** and delivered with **Amazon CloudFront** for speed and security.

---

## Architecture

![AWS Static Website Diagram](diagram/aws-static-website.png)

**Main services:**

- **S3** → keeps the website files (HTML, CSS, images).
- **CloudFront** → makes the site faster worldwide and adds HTTPS.
- **ACM** → SSL certificate for HTTPS.
- **Route 53** → optional, to use your own domain.

---

## Why this pattern?

- Simple way to publish a website.
- Very low cost and easy to manage.
- Works for portfolios, landing pages, or company sites.

---

## What’s inside

- Architecture diagram
- Terraform code for S3, CloudFront, ACM, and Route 53
- Example static website with logo
- Deployment scripts
