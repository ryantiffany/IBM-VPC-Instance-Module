resource "ibm_is_instance" "instance" {
  name           = var.name
  vpc            = var.vpc_id
  zone           = var.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = var.ssh_key_ids
  resource_group = var.resource_group

  user_data = var.user_data != "" ? var.user_data : file("${path.module}/init.yml")


  primary_network_interface {
    subnet          = var.subnet_id
    security_groups = [var.security_group_id != null ? var.security_group_id : null]
  }

  boot_volume {
    name = "${var.name}-boot-volume"
  }

  tags = concat(var.tags, ["resource_type:ibm_is_instance", "zone:${var.zone}"])
}
