

# resource "aws_instance" "my_instance2" {
#    ami = "ami-0f8e81a3da6e2510a"
#    instance_type = "t2.micro"
#    key_name = "terraform"
#    tags = {
#        Name = "terroform_2"
#    }
#}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "my_instance2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.pem_key
    tags = {
       Name = "terroform_1"
    }
}

resource "aws_s3_bucket" "s3_backend" {
     bucket = var.bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_backend_sse" {
  bucket = aws_s3_bucket.s3_backend.id

  rule {
    apply_server_side_encryption_by_default {
      
       sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_backend_versioning" {
  bucket = aws_s3_bucket.s3_backend.id
  versioning_configuration {
    status = "Enabled"
  }
  depends_on = [
    aws_s3_bucket_server_side_encryption_configuration.s3_backend_sse
  ]
}

resource "aws_dynamodb_table" "dynamobd_state_locking" {
   name = var.dynamodb_name
   billing_mode   = "PAY_PER_REQUEST"
   hash_key = var.hash_key
   attribute {
        name = var.hash_key
        type = "S"
   }
}
