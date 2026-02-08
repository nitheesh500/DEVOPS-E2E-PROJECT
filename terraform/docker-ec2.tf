# resource "aws_instance" "this" {
#   ami                    = "ami-0532be01f26a3de55" # This is our devops-practice AMI ID
#   vpc_security_group_ids = [aws_security_group.allow_all_docker.id]
#   instance_type          = "t3.medium"

#   # 20GB is not enough
#   root_block_device {
#     volume_size = 50  # Set root volume size to 50GB
#     volume_type = "gp3"  # Use gp3 for better performance (optional)
#   }
#   user_data = file("bootstrap.sh")
#   tags = {
#     Name    = "ec2-docker-jenkins"
#   }
# }

resource "aws_instance" "this" {
  ami                    = "ami-0532be01f26a3de55" # This is our devops-practice AMI ID
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  instance_type          = "t2.large"

  instance_market_options {
    market_type = "spot"

    spot_options {
      spot_instance_type             = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }
  # 20GB is not enough
  root_block_device {
    volume_size = 38  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  user_data = file("bootstrap.sh")
  tags = {
    Name    = "ec2-docker-jenkins"
  }
}


resource "aws_security_group" "allow_all" {
  name        = "allow_all_docker"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
output "vm_ip" {
  value       = aws_instance.this.public_ip
}