data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["myvpc"]
  }
}

data "aws_subnet_ids" "availabledbsubnet" {
  vpc_id = data.aws_vpc.vpc_available.id
  filter {
    name   = "tag:Name"
    values = ["database_subnet_az_1a*", "database_subnet_az_1b*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_security_group" "mysecurity" {
  filter {
    name   = "tag:Name"
    values = ["mysecuritygroup"]
  }
}
