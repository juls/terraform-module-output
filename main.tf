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

  ip_addresses = "${join(",",docker_container.ubuntu.*.ip_address)}"
  # => works as expected for "terraform apply", but fails with
  # "Resource 'docker_container.ubuntu' does not have attribute 'ip_address' for variable 'docker_container.ubuntu.*.ip_address'"
  # on "terraform destroy"
}
