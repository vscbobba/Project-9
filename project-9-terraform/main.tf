resource "aws_vpc" "vpc-9" {
     cidr_block = "20.0.0.0/16"
     enable_dns_hostnames = true
     enable_dns_support = true
     tags = {
        Name = "myvpc"
    }
}
resource "aws_subnet" "subnet-9" {
    cidr_block = "20.0.1.0/24"
    vpc_id = aws_vpc.vpc-9.id
    map_public_ip_on_launch = true
    tags = {
        Name = "mysubnet"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.vpc-9.id
    tags = {
        Name = "myGW"
    }
}
resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.vpc-9.id
     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
     }    
}
resource "aws_route_table_association" "rt-associate" {
    subnet_id = aws_subnet.subnet-9.id
    route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "mysg" {
     vpc_id = aws_vpc.vpc-9.id
     name = "my-sg"
     dynamic ingress {
            iterator = port
            for_each = var.port
            content {
            description      = "TLS from VPC"
            from_port        =  port.value
            to_port          =  port.value
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            }
        }
        egress {
            from_port        = 0
            to_port          = 0
            protocol         = "-1"
            cidr_blocks      = ["0.0.0.0/0"]
        }

        tags = {
            Name = "allow_tls"
        }
}
resource "aws_key_pair" "mykey" {
     key_name = "project-9-key"
     public_key = file("/home/venkat/.ssh/id_ed25519.pub")      
}

resource "aws_instance" "Jenkins" {
     key_name = aws_key_pair.mykey.id
     vpc_security_group_ids = [aws_security_group.mysg.id]
     subnet_id = aws_subnet.subnet-9.id
     root_block_device {
            volume_size = 15
         }
     user_data = file("jenkins_data.tpl")
     ami = var.ami[0]
     instance_type = var.instance_type[2]
     tags = {
          Name = "Jenkins"
         }
}
resource "aws_instance" "ansible_manager" {
     key_name = aws_key_pair.mykey.id
     vpc_security_group_ids = [aws_security_group.mysg.id]
     subnet_id = aws_subnet.subnet-9.id
     user_data = file("ansible_manager_data.tpl")
     ami = var.ami[1]
     instance_type = var.instance_type[0]
     tags = {
          Name = "ansible_manager"
         }
    provisioner "file" {
          source      = "/home/venkat/DEVOPS/Project-9/Ansible"
          destination = "/tmp"
        }
         connection {
          type        = "ssh"
          user        = "ec2-user"             # Replace with your SSH user
          private_key = file("~/.ssh/id_ed25519")  # Replace with your private key path
          host  = self.public_ip
        }
}

resource "aws_instance" "ansible_docker" {
     key_name = aws_key_pair.mykey.id
     vpc_security_group_ids = [aws_security_group.mysg.id]
     subnet_id = aws_subnet.subnet-9.id
     user_data = file("ansible_docker_data.tpl")
     ami = var.ami[0]
     instance_type = var.instance_type[2]
     tags = {
          Name = "docker"
         }
}
