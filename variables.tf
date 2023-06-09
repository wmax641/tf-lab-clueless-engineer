variable "base_name" {
  type    = string
  default = "lab-clueless-engineer"
}
variable "common_tags" {
  default = {
    "project" = "tf-lab-clueless-engineer"
  }
}
variable "instance_count" {
  type        = number
  default     = 2
  description = "The number of lab instances. If 0, VPC endpoitns won't be created to save money"
}

variable "cidr_block" {
  type    = string
  default = "10.13.37.0/24"
}
