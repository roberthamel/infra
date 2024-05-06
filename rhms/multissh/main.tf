resource "null_resource" "multissh" {
  provisioner "local-exec" {
    command = "make -f ../../shared/multissh/Makefile load"
  }
}
