provider "aws" {
  region = "ap-south-1"
}

data "aws_ami" "centos7_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_security_group" "only_ssh" {
  name = "Only-SSH"
  vpc_id = "<your-vpc-id>"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow SSH from All"
  }
}

resource "aws_volume_attachment" "vol_att1" {
  device_name = "/dev/xvdb"
  volume_id   = "${aws_ebs_volume.calc_vol.id}"
  instance_id = "${aws_instance.complex_calculator.id}"
}

resource "aws_ebs_volume" "calc_vol" {
  availability_zone = "ap-south-1a"
  type = "gp2"
  size = 100
  tags = {
    Name = "For Complex Calculator"
  }
}

resource "null_resource" "calculator_node" {

  triggers = {
    volume_attachment = "${aws_volume_attachment.vol_att1.id}"
  }

  connection {
    host = "${aws_instance.complex_calculator.public_ip}"
    type     = "ssh"
    user     = "centos"
    private_key = "${file("/Users/navneet/Downloads/navneet-test.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo mkdir -p /data",
      "sudo mke2fs -t ext4 /dev/nvme1n1",
      "sudo mount /dev/nvme1n1 /data -o noatime"
    ]
  }
}

resource "aws_instance" "complex_calculator" {
  ami           = "${data.aws_ami.centos7_ami.id}"
  instance_type = "c5.large"
  key_name      = "navneet-test"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = ["${aws_security_group.only_ssh.id}"]
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    Name = "Equation-Calculator"
    Env = "Prod"
  }
}
