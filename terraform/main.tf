provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "boardgame_sg" {
  name        = "boardgame-security-group"
  description = "A security group for boardgame project"
  vpc_id      = "vpc-07835fe3e95b328a1" # Replace with your VPC ID

  # Inbound rule for SMTP (Port 25)
  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SMTP from anywhere
  }

  # Inbound rule for HTTP (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }

  # Inbound rule for HTTPS (Port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS from anywhere
  }

  # Inbound rule for SSH (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  # Inbound rule for Custom TCP (Ports 3000–10000)
  ingress {
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow custom TCP from anywhere
  }

  # Inbound rule for Custom TCP (Ports 3000–10000)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow custom TCP from anywhere
  }

  # Inbound rule for Custom TCP (Ports 3000–10000)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow custom TCP from anywhere
  }

  # Inbound rule for SMTPS (Port 465)
  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SMTPS from anywhere
  }

  # Outbound rules (allow all outbound traffic by default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

output "security_group_id" {
  value = aws_security_group.boardgame_sg.id
}



resource "aws_instance" "master" {
  ami           = "ami-084568db4383264d4" # Ubuntu 24.04 AMI
  instance_type = "t3.medium"
  #subnet_id     = aws_subnet.subnet_a.id
  #security_groups             = [aws_security_group.boardgame_sg.id]
  security_groups             = ["sg-003019f96bc56777b"]
  associate_public_ip_address = true
  subnet_id                   = "subnet-02aceeee6a46b30cd"
  key_name                    = "kops-key"
  root_block_device {
    volume_size           = 25    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (gp2) volume type
    delete_on_termination = true  # Volume will be deleted when the instance is terminated
  }
  count = 1

  tags = {
    Name = "master"
  }
  # depends_on = [aws_security_group.boardgame_sg]
}

resource "aws_instance" "worker" {
  ami           = "ami-084568db4383264d4" # Ubuntu 24.04 AMI
  instance_type = "t3.small"
  #subnet_id     = aws_subnet.subnet_b.id
  #security_groups             = [aws_security_group.boardgame_sg.id]
  security_groups             = ["sg-003019f96bc56777b"]
  associate_public_ip_address = true
  key_name                    = "kops-key"
  subnet_id                   = "subnet-02aceeee6a46b30cd"
  root_block_device {
    volume_size           = 25    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (gp2) volume type
    delete_on_termination = true  # Volume will be deleted when the instance is terminated
  }
  count = 2

  tags = {
    Name = "worker"
  }

  # depends_on = [aws_security_group.boardgame_sg]
}

resource "aws_instance" "sonarqube" {
  ami           = "ami-084568db4383264d4" # Ubuntu 24.04 AMI
  instance_type = "t3.small"
  #subnet_id     = aws_subnet.subnet_a.id
  #security_groups             = [aws_security_group.boardgame_sg.id]
  security_groups             = ["sg-003019f96bc56777b"]
  associate_public_ip_address = true
  key_name                    = "kops-key"
  count                       = 1
  subnet_id                   = "subnet-02aceeee6a46b30cd"
  root_block_device {
    volume_size           = 20    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (gp2) volume type
    delete_on_termination = true  # Volume will be deleted when the instance is terminated
  }
  tags = {
    Name = "sonarqube"
  }

  # depends_on = [aws_security_group.boardgame_sg]
}

resource "aws_instance" "nexus" {
  ami           = "ami-084568db4383264d4" # Ubuntu 24.04 AMI
  instance_type = "t3.small"
  #subnet_id     = aws_subnet.subnet_a.id
  #security_groups             = [aws_security_group.boardgame_sg.id]
  security_groups             = ["sg-003019f96bc56777b"]
  associate_public_ip_address = true
  key_name                    = "kops-key"
  count                       = 1
  subnet_id                   = "subnet-02aceeee6a46b30cd"
  root_block_device {
    volume_size           = 20    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (gp2) volume type
    delete_on_termination = true  # Volume will be deleted when the instance is terminated
  }
  tags = {
    Name = "nexus"
  }

  # depends_on = [aws_security_group.boardgame_sg]
}


resource "aws_instance" "jenkins" {
  ami           = "ami-084568db4383264d4" # Ubuntu 24.04 AMI
  instance_type = "t2.large"
  #subnet_id     = aws_subnet.subnet_a.id
  #security_groups             = [aws_security_group.boardgame_sg.id]
  security_groups             = ["sg-003019f96bc56777b"]
  associate_public_ip_address = true
  key_name                    = "kops-key"
  count                       = 1
  subnet_id                   = "subnet-02aceeee6a46b30cd"
  root_block_device {
    volume_size           = 30    # Size of the root volume in GB
    volume_type           = "gp3" # General Purpose SSD (gp2) volume type
    delete_on_termination = true  # Volume will be deleted when the instance is terminated
  }
  tags = {
    Name = "jenkins"
  }

  # depends_on = [aws_security_group.boardgame_sg]
}
