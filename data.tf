data "aws_iam_instance_profile" "instance_profile" {
  name = "ec2"
}
data "aws_availability_zone" "az" {
  name                   = "ap-south-1a"
  all_availability_zones = false
  state                  = "available"
}
data "aws_key_pair" "key" {
  key_name = "firstkey"
}


data "aws_subnet" "selected" {
  availability_zone = "ap-south-1a"
  filter {
    name   = "tag:Name"
    values = ["public_subnet_az_1a"]
  }
}
data "aws_security_groups" "sg" {
  tags = {
    Name = "mysecuritygroup"
  }
}

