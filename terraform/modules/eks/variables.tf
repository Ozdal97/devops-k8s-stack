variable "cluster_name" {
  type        = string
  description = "EKS cluster ismi"
}

variable "kubernetes_version" {
  type    = string
  default = "1.29"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Worker node ve control plane icin subnet ID listesi (en az 2 AZ)"
}

variable "public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "desired_size" {
  type    = number
  default = 3
}

variable "max_size" {
  type    = number
  default = 6
}

variable "min_size" {
  type    = number
  default = 2
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.large"]
}
