################################################################################
# VPC
################################################################################

resource "aws_vpc" "myvpc" {
  cidr_block                       = var.cidr
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }
}

###############################################################################
# Internet Gateway
###############################################################################

resource "aws_internet_gateway" "myigw" {

  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = var.igw_tag
  }
}

################################################################################
# Public subnet
################################################################################

resource "aws_subnet" "publicsubnet1" {
  vpc_id                          = aws_vpc.myvpc.id
  cidr_block                      = var.public_subnets_cidr_1
  availability_zone               = data.aws_availability_zones.available_1.names[0]
  map_public_ip_on_launch         = var.map_public_ip_on_launch

  tags = {
   Name = var.public_subnet_tag_1
  }
}
resource "aws_subnet" "publicsubnet2" {
  vpc_id                          = aws_vpc.myvpc.id
  cidr_block                      = var.public_subnets_cidr_2
  availability_zone               = data.aws_availability_zones.available_1.names[1]
  map_public_ip_on_launch         = var.map_public_ip_on_launch

  tags = {
   Name = var.public_subnet_tag_2
  }
}

################################################################################
# Database subnet
################################################################################

resource "aws_subnet" "privatesubent1" {
  vpc_id                          = aws_vpc.myvpc.id
  cidr_block                      = var.database_subnets_cidr_1
  availability_zone               = data.aws_availability_zones.available_1.names[0]
  map_public_ip_on_launch         = false

  tags = {
    Name = var.private_subnet_tag_1
  }
}
resource "aws_subnet" "privatesubent2" {
  vpc_id                          = aws_vpc.myvpc.id
  cidr_block                      = var.database_subnets_cidr_2
  availability_zone               = data.aws_availability_zones.available_1.names[1]
  map_public_ip_on_launch         = false

  tags = {
    Name = var.private_subnet_tag_2
  }
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = var.publicroutetable_tag
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.publicroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id
}

################################################################################
# Database route table
################################################################################

resource "aws_route_table" "privateroutetable" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = var.privateroutetable_tag
  }
}

################################################################################
# Route table association with subnets
################################################################################

resource "aws_route_table_association" "publicroutetable_association_1" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.publicroutetable.id
}
resource "aws_route_table_association" "publicroutetable_association_2" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.publicroutetable.id
}
resource "aws_route_table_association" "privateroutetable_association_1" {
  subnet_id      = aws_subnet.privatesubent1.id
  route_table_id = aws_route_table.privateroutetable.id
}
resource "aws_route_table_association" "privateroutetable_association_2" {
  subnet_id      = aws_subnet.privatesubent2.id
  route_table_id = aws_route_table.privateroutetable.id
}

###############################################################################
# Security Group
###############################################################################

resource "aws_security_group" "sg" {
  name        = "mysecuritygroup"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress = [
    {
      description      = "All traffic"
      from_port        = 0    # All ports
      to_port          = 0    # All Ports
      protocol         = "-1" # All traffic
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Outbound rule"
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  tags = {
    Name = "mysecuritygroup"
  }
}
