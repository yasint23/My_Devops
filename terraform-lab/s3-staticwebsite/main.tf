provider "aws" {
    region     = "us-west-2"
}

resource "aws_s3_bucket" "blog" {
    bucket = "${var.blog_bucket_subdomain}.${var.root_domain}"
}

resource "aws_s3_bucket_website_configuration" "blog" {
    bucket = aws_s3_bucket.blog.id
    
    index_document {
        suffix = "index.html"
    }
    
    error_document {
        key = "error.html"
    }
}

resource "aws_s3_bucket_acl" "blog_bucket_acl" {
    bucket = aws_s3_bucket.blog.id
    acl    = "public-read"
}

resource "aws_s3_object" "upload_object" {
    for_each = fileset("html/", "*")
    bucket = aws_s3_bucket.blog.id
    key    = each.value
    source = "html/${each.value}"
    etag = filemd5("html/${each.value}")
    content_type = "text/html"
}

resource "aws_s3_bucket_policy" "read_access_policy" {
    bucket = aws_s3_bucket.blog.id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.blog.id}/*"
            ]
        }
    ]
}
POLICY
}