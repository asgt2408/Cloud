#!/bin/bash

# after making a new bucket by running
# aws s3 mb s3://(BUCKET) --region (REGION)

BUCKET="resume-project-byashu"
REGION="ap-south-1"
FOLDER="./resume"

# 1. Enable the static wwebsite hosting

aws s3 website s3://$BUCKET/ --index-document index.html --error-document error.html
echo "✔ Static website hosting enabled"

# 2. Disable Block public access

aws s3api put-public-access-block \
  --bucket resume-project-byashu \
  --public-access-block-configuration \
  BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false

  echo "✔ Block Public Access disabled"

# 3. Create a temporary policy file
cat > resume.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::$BUCKET/*"
  }]
}
EOF

# 4. Apply the public-read bucket policy
aws s3api put-bucket-policy --bucket $BUCKET --policy file://$FOLDER/resume.json

echo "✔ Bucket policy applied to allow public read access"


# 5. Upload website files
aws s3 cp $FOLDER s3://$BUCKET/ --recursive

echo "✔ Files uploaded to S3"


# 6. Output the site URL
echo "🌐 Your website is live at:"
echo "http://$BUCKET.s3-website.$REGION.amazonaws.com"

