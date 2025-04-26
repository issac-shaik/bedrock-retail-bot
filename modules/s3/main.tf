resource "aws_s3_bucket" "phone_images" {
  bucket = "retail-phone-images-${random_id.suffix.hex}"

  force_destroy = true # (easier during testing phase to allow delete even if files inside)
  acl = "public-read"
}

resource "aws_s3_bucket_public_access_block" "phone_images_access" {
  bucket = aws_s3_bucket.phone_images.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.phone_images.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = [
        "s3:GetObject"
      ],
      Resource = "${aws_s3_bucket.phone_images.arn}/*"
    }]
  })
}

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  phone_images = [
    "galaxys25.jpg",
    "galaxys25ultra.jpg",
    "iphone11.jpg",
    "iphone16.jpg",
    "iphone16e.jpg",
    "iphone16pro.jpg",
    "iphone16promax.jpg",
    "oneplus13.jpg",
    "oneplus13t.jpg",
    "pixel9.jpg",
    "pixel9pro.jpg",
    "pixel9proxl.jpg"    
  ]
}

resource "aws_s3_object" "phone_images" {
  for_each = toset(local.phone_images)

  bucket = aws_s3_bucket.phone_images.id
  key    = each.value
  source = "${path.module}/../../images/${each.value}"
  content_type = "image/png"
}

