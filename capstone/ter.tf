terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }

}

provider "aws" {

  region = "ca-central-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0748249a1ffd1b4d2"
  instance_type = "t2.medium"

  tags = {
    Name = "terraform"
  }
}
