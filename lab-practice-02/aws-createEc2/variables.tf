# variable "ACCTID" {
#   default = 123456789012
# }
variable "TAG_MANAGED" {
  default = "tf-managed"
}
variable "InstanceType" {
  default = "t2.micro"
}

# variable "InstanceSubnetID" {
#   default = "subnet-xxxxxx"
# }
# variable "InstancePriIP" {
#   default = "172.31.0.101"
# }
# variable "InstanceSGID" {
#   default = "sg-xxxxxx"
# }

variable "InstanceTagName" {
  default = "labtest-username-01"
}
variable "RootVolumeType" {
  default = "gp2"
}
variable "RootVolumeSize" {
  default = 10
}