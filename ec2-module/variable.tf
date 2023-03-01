variable "vpc_id" {
  type= string
  default = "myvpc"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "associate_public_ip" {
  type    = bool
  default = true
}
variable "az" {
  type    = string
  default = "us-east-1a"
}
variable "disable_api_termination" {
  type    = bool
  default = false
}
variable "instance_profile" {
  type    = string
  default = "ec2"
}
variable "key" {
  type    = string
  default = "dev-account"
}
variable "sg" {
  type    = list(any)
 
}
variable "subnet_id" {
  type    = string
}
variable "volume_size" {
  type    = number
  default = 10
}
variable "application" {
  type    = string
  default = "myapplication"
}
