resource "aws_instance" "myinstance" {
  ami           ="ami-09ba48996007c8b50"
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip
  availability_zone           = data.aws_availability_zone.az.id
  disable_api_termination     = var.disable_api_termination
  iam_instance_profile        = data.aws_iam_instance_profile.instance_profile.role_name
  key_name                    = data.aws_key_pair.key.key_name
  security_groups             = null
  vpc_security_group_ids      = data.aws_security_groups.sg.ids
  subnet_id                   = data.aws_subnet.selected.id
  user_data                   = file("${path.module}/user-data.sh")
  hibernation = false
  credit_specification {
    cpu_credits = "standard"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = "gp2"
    tags = {
      Name         = "ec2_production"
      application  = var.application
    }
  }
  
  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
  tags = {
    Name         = "ec2_production"
    application  = var.application
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "ap-south-1a"
  size              = 10
  snapshot_id       = null
  type              = "gp2"
  tags = {
    Name         = "ebs_volume"
    application  = var.application
  }
}

