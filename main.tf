resource "docker_image" "ubuntu" {
  name = "ubuntu:14.04.2"
}

resource "docker_container" "ubuntu" {
  count = "2"
  image = "${docker_image.ubuntu.latest}"
  name = "test${count.index+1}"
  hostname = "test${count.index+1}"
}

output "ip_addresses" {
  value = "${join(",",docker_container.ubuntu.*.ip_address)}"
}

module "test" {
  source = "module/"

  # ip_addresses = "1.2.3.8,1.2.3.9"
  # => works as excpected

  # ip_addresses = "${docker_container.ubuntu.ip_addresses}"
  # => fails with "failed to render test.tpl: 1:3: unknown variable accessed: param1" (NOT param2, which contains the ip address)

  # ip_addresses = "${join(",",docker_container.ubuntu.*.ip_address)}"
  # => fails with "Resource 'docker_container.ubuntu' does not have attribute 'ip_address' for variable 'docker_container.ubuntu.*.ip_address'"
}
