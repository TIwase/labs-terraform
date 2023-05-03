# Create VPC
resource "aws_vpc" "test" {
  cidr_block = "172.32.0.0/16"
  tags = {
    Name = "labtest-vpc-01"
    Managed = "tf-managed"
  }
}
# Create Subnet
resource "aws_subnet" "subnet_apne1c" {
  vpc_id     = aws_vpc.test.id
  cidr_block = "172.32.1.0/24"
  availability_zone = "ap-northeast-1c"
  depends_on = [ 
    aws_vpc.test 
  ]
  tags = {
    Name = "labtest-subnet-01"
    Managed = "tf-managed"
  }
}
# Create Security Group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test.id

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