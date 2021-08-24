variable instance_name {
    type = string
    sensitive = true
}

variable AWS_ACCESS_KEY_ID {
    type = string
    sensitive = true
}

variable AWS_SECRET_ACCESS_KEY {
    type = string
    sensitive = true
}

variable AWS_DEFAULT_REGION {
    type = string
    sensitive = true
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  subnet_id = aws_subnet.main.id

  tags = {
    Name = var.instance_name
  }
}