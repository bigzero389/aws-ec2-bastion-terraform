# AWS용 프로바이더 구성
provider "aws" {
  profile = "default"
  region = "ap-northeast-2"
}

variable "tagging" {
  type = map
  default = {
    name = "bastion"
    creator = "dyheo"
    group = "HISTECH-bastion"
  }

}

locals {
  pem_file = "dyheo-histech"

  ## EC2 를 만들기 위한 로컬변수 선언
  ami = "ami-0e4a9ad2eb120e054" ## AMAZON LINUX 2
  instance_type = "t2.micro"
}

## VPC ID 로 vpc id 를 가져온다.
data "aws_vpc" "selected" {
  id = "vpc-0b20ad1cf24894d5c" # VPC_HIST_TECH
}

## SUBNET ID 로 subnet 을 가져온다.
data "aws_subnet" "selected" {
  id = "subnet-010d6f0feb5bf6874" # TECH_PUBLIC_SUBNET_2A
}


# AWS Security Group
resource "aws_security_group" "sg" {
  name        = "HISTECH-bastion-dyheo-sg"
  description = "HISTECH bastion for dyheo by terraform"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress = [
    {
      description      = "SSH open"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      type             = "ssh"
      cidr_blocks      = ["125.177.68.23/32", "211.206.114.80/32"]
      #cidr_blocks      = ["211.206.114.80/32"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = false
      description = "outbound all"
    }
  ]

  tags = {
    Name = "${var.tagging["name"]}-sg",
    Creator= "${var.tagging["creator"]}",
    Group = "${var.tagging["group"]}"
  }
}

# AWS EC2
resource "aws_instance" "bastion" {
  associate_public_ip_address = true

  ami = "${local.ami}"
  instance_type = "${local.instance_type}"
  key_name = "${local.pem_file}"

  subnet_id = "${data.aws_subnet.selected.id}"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  tags = {
    Name = "${var.tagging["name"]}-ec2",
    Creator= "${var.tagging["creator"]}",
    Group = "${var.tagging["group"]}"
  }

# EC2 preconfig
#  provisioner "remote-exec" {
#    connection {
#      host = self.public_ip
#      user = "ec2-user"
#      private_key = "${file("~/.ssh/${local.pem_file}.pem")}"
#    }
#    inline = [
#      "echo 'repository set'",
#      "sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y",
#      "sudo yum update -y"
#    ]
#  }
  ## ANSIBLE playbook 을 삽입하는 경우 여기를 수정한다.
#  provisioner "local-exec" {
#    command = "echo '[inventory] \n${self.public_ip}' > ./inventory"
#  }
#  provisioner "local-exec" {
#    command = "ansible-playbook --private-key='~/.ssh/dyheo-histech-2.pem' -i inventory monolith.yml"
#  }
}

## EC2 를 만들면 public ip 를 print 해준다.
output "instance-public-ip" {
  value = "${aws_instance.bastion.public_ip}"
}

