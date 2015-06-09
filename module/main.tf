variable "ip_addresses" {}

resource "template_file" "test" {
  filename = "${path.module}/test.tpl"
  count = "2"

  vars {
    param1 = "some parameter"
    param2 = "${element(split(",",var.ip_addresses), count.index)}"
  }

  provisioner "local-exec" {
    command = "echo ${self.rendered}"
  }
}
