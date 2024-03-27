provider "aws" {
  region = "ca-central-1"  # AWS Canada Central region
}

# Define VPC, subnets, and other necessary resources
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  # Add other VPC configurations as needed
}

resource "aws_subnet" "private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${1 + count.index}.0/24"  # Private subnet CIDR blocks
  availability_zone = "ca-central-1a"  # Update with your desired AZ in ca-central region
}

resource "aws_subnet" "public_subnet" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${101 + count.index}.0/24"  # Public subnet CIDR blocks
  availability_zone = "ca-central-1a"  # Update with your desired AZ in ca-central region
}

# Define AWS Launch Template
resource "aws_launch_template" "example" {
  name_prefix   = "example-lt-"
  image_id      = "ami-0748249a1ffd1b4d2"  # Update with your desired AMI
  instance_type = "t2.medium"
  # Add other necessary parameters for your launch template
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "scrum1" {
  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }

  min_size             = 2
  max_size             = 5
  desired_capacity     = 3
  vpc_zone_identifier  = aws_subnet.private_subnet[*].id  # Use correct subnet IDs

  # Add other necessary configurations for your Auto Scaling Group
}

# Output the ASG name
output "autoscaling_group_name" {
  value = aws_autoscaling_group.scrum1.name
}

#s3 Bucket


module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "devscrum1-bucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
