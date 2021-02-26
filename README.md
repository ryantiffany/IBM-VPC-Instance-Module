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
  source            = "git::https://github.com/ryantiffany/IBM-VPC-Instance-Module.git"
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  ssh_key_ids       = [var.ssh_key]
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
| user\_data\_script | Script to run during the virtual server instance initialization. Defaults to an [Ubuntu specific script](https://github.com/ryantiffany/IBM-VPC-Instance-Module/blob/main/init.yml) when set to empty | `string` | `""` | no |
| profile\_name | Instance profile to use for the virtual server instance | `string` | `"cx2-2x4"` | no |
| ssh\_key_ids\ | List of SSH key IDs to inject into the virtual server instance | `list(string)` | n/a | yes |
| tags | List of tags to add on all created resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the virtual server instance |
| primary_network_interface_id | ID of the virtual server instances primary network interface  | 
| primary_ip4_address | Primary private IP address of the virtual server instance |

## Gathering Input Data
The quickest way to look up VPC instance profiles and image names is via [Cloud Shell](https://cloud.ibm.com/docs/cloud-shell?topic=cloud-shell-getting-started). IBM Cloud Shell is a free service that gives you access to your applications and infrastructure, from any web browser. It includes handy tools like [Terraform]() and [jq] as well as access to the [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started)

**Cloud Shell setup** 

 - Open the IBM Cloud console (cloud.ibm.com) in your browser and log in if needed.
 - Invoke Cloud Shell by clicking on the button at the top, right-hand corner of the browser window.

![Cloud Shell Icon](https://dsc.cloud/quickshare/Shared-Image-2020-09-23-09-26-23.png)

### Available Subnets for your VPC
Find all the subnets available to your VPC. In this example our VPC is named `rt-test-lab` and it is in the us-south region. 

```shell
$ ibmcloud target -r us-south
$ ibmcloud is subnets --output json | jq -r '.[] | select(.vpc.name=="rt-test-lab") | .name,.id'
```

This will return the name followed by the ID of the subnets in the VPC. 

### Available images
Find all the private images in the current region that are available for deployment. Private images are custom images that have been [imported in to the VPC](). 

```shell
$ ibmcloud images --visibility private --json | jq -r '.[] | select(.status=="available") | .name,.id'
```

Find all the public images in the current region that are available for deployment.

```shell
$ ibmcloud images --visibility public --json | jq -r '.[] | select(.status=="available") | .name,.id'
```

Filter on OS family (in this example `Ubuntu`

```shell
$ ibmcloud is images --visibility public --json | jq -r '.[] | select(.operating_system.family=="Ubuntu Linux") | select(.status=="available") | .name, .id'
```

### Security Groups
Find all the Security groups for your VPC. In this example our VPC is named `rt-test-lab`.

```
ibmcloud is security-groups --output json | jq -r '.[] | select(.vpc.name=="rt-test-lab") | .name,.id'
```
