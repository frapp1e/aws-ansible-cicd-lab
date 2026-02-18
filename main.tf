provider "aws" {
  region = "eu-west-1"
}

# ------------------------------
# VPC
# ------------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "VPC-Lab" }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}


# ------------------------------
# Subnet
# ------------------------------
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = { Name = "Subnet-Lab" }
}

# ------------------------------
# Security Group
# ------------------------------
resource "aws_security_group" "sg_lab" {
  name        = "sg_lab"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # para pruebas, luego restringir a tu IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------------
# Key Pair
# ------------------------------
resource "aws_key_pair" "lab_key" {
  key_name   = "aws-lab-key"
  public_key = file("~/.ssh/aws-rocky.pub")
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "web" {
  ami                    = "ami-080ecf65f4d838a6e"  # Amazon Linux
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.sg_lab.id]
  key_name               = aws_key_pair.lab_key.key_name
  associate_public_ip_address = true

  tags = { Name = "EC2-Lab" }
}
# Elastic IP para la EC2
resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
}

# ------------------------------
# Output
# ------------------------------
output "ec2_ip" {
  value = aws_instance.web.public_ip
}

# Output de la Elastic IP
output "elastic_ip" {
  value = aws_eip.web_eip.public_ip
}
