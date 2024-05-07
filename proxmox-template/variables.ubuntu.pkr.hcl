variable "vm_name" {
  type = string
  default = "ubuntu-server-noble"
}

variable "vm_password" {
  type = string
  default = "${env("PACKER_VM_PASSWORD")}"
}
