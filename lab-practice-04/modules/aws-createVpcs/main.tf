# Create VPC
resource "aws_vpc" "test" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name_tag
    Managed = "tf-managed"
  }
}
# Create Subnet
resource "aws_subnet" "subnet_apne1c" {
  vpc_id     = aws_vpc.test.id
  cidr_block = var.subnet_cidr
  availability_zone = var.subnet_az
  depends_on = [ 
    aws_vpc.test 
  ]
  tags = {
    Name = var.subnet_name_tag
    Managed = "tf-managed"
  }
}
# Create Security Group
resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow SSH and TLS inbound traffic"
  vpc_id      = aws_vpc.test.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.test.cidr_block]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.test.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }
  depends_on = [ 
    aws_vpc.test 
  ]
  tags = {
    Name = "labtest-sg-01"
    Managed = "tf-managed"
  }
}