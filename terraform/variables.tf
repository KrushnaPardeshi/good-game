variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
}

variable "root_volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
}

variable "instance_name" {
  description = "The name tag to assign to the instance"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private key file for SSH access"
  type        = string
}
