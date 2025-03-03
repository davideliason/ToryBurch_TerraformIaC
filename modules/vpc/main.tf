resource "aws_vpc" "main-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = var.tags # this is a map of tags
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main-vpc.cidr_block, 4, 0) #10.17.0.0/20
  availability_zone       = var.availability_zone-1
  map_public_ip_on_launch = var.map_public_ip_on_launch

  #add custom tags
  tags = merge(var.tags, {
    Name = "ToryBurch-public-subnet-2a-parallel"
  })
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main-vpc.cidr_block, 4, 2) #10.17.32.0/20
  availability_zone       = var.availability_zone-2
  map_public_ip_on_launch = var.map_public_ip_on_launch

  #add custom tags
  tags = {
    Name = "ToryBurch-public-subnet-2b-parallel"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main-vpc.cidr_block, 4, 1) #10.17.16.0/2
  
  availability_zone       = var.availability_zone-1
  map_public_ip_on_launch = false

  #add custom tags
  tags = merge(var.tags, {
    Name = "ToryBurch-private-subnet-2a-parallel"
  })
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = cidrsubnet(aws_vpc.main-vpc.cidr_block, 4, 3) #10.17.48.0/20

  availability_zone       = var.availability_zone-2
  map_public_ip_on_launch = false

  #add custom tags
  tags = {
    Name = "ToryBurch-private-subnet-2b"
  }
}

resource "aws_instance" "web_server-1" {
  ami                         = "ami-027951e78de46a00e" # Ubuntu 20.04 AMI 
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_server_sg.id]
  user_data                   = <<-EOF
                                #!/bin/bash
                                sudo yum update -y
                                sudo yum install httpd -y
                                sudo systemctl start httpd
                                sudo bash -c 'echo Your very first web server > /var/www/html/index.html'
                                EOF

  tags = merge(var.tags, {
    Name = "ToryBurch-web-server-1"
  })
}

# create security group for web_server-1
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #add port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "ToryBurch-web-server-sg"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-vpc.id

  #add custom tags
  tags = merge(var.tags, {
    Name = "ToryBurch-igw-parallel"
  })
}



#public subnet route table  
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  #add custom tags
  tags = merge(var.tags, {
    Name = "ToryBurch-public-route-table-parallel"
  })
}

#associate public subnet with public route table
resource "aws_route_table_association" "public-subnet-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

#associate second public SN with public RT
resource "aws_route_table_association" "public-subnet-association-2" {
  subnet_id     = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}
