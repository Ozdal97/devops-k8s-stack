variable "name" { type = string }

variable "cluster_name" { type = string }

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "tags" {
  type    = map(string)
  default = {}
}
