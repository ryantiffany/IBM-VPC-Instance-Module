# Compute Instance Module for IBM CLoud VPC 
Terraform module for deploying a compute instance in to an IBM Cloud VPC.  

## Usage
If you need to include an IBM Cloud VPC Instance in your deployment you can use the following code:

### Using the default module cloud-init script

```
data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_is_zones" "mzr" {
  region = var.region
}

module instance {
  source            = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Instance-Module.git"
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  ssh_keys          = [var.ssh_key]
  resource_group    = data.ibm_resource_group.group.id
  name              = var.name
  zone              = data.ibm_is_zones.mzr.zones[2]
  security_group_id = var.security_group_id
  tags              = concat(var.tags, ["project:${var.name}"])
  user_data         = var.user_data
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource\_group\_id | ID of the resource group to associate with the virtual server instance | `string` | n/a | yes |
| vpc\_id | ID of the VPC where to create the virtual server instance | `string` | n/a | yes |
| subnet\_id | ID of the subnet that will be attached to the virtual server instance | `string` | n/a | yes |
| name | Name of the virtual server instance | `string` | n/a | yes |
| zone | VPC zone where the virtual server instance will be created. | `string` | n/a | yes |
| security\_group\_id | ID of the security group to attach to the primary interface | `string` | `""` | yes | 
| image\_name | Name of the image to use for the virtual server instance | `string` | `"ibm-ubuntu-20-04-minimal-amd64-2"` | no |
| user\_data\_script | Script to run during the virtual server instance initialization. Defaults to an [Ubuntu specific script](https://github.com/cloud-design-dev/IBM-Cloud-VPC-Instance-Module/blob/main/init.yml) when set to empty | `string` | `""` | no |
| profile\_name | Instance profile to use for the virtual server instance | `string` | `"cx2-2x4"` | no |
| ssh\_key_ids\ | List of SSH key IDs to inject into the virtual server instance | `list(string)` | n/a | yes |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the virtual server instance |
| primary_network_interface_id | ID of the virtual server instances primary network interface  | 
| primary_ip4_address | Primary private IP address of the virtual server instance |