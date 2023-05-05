terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
    }
  }
}

variable "exoscale_api_key" {
  type = string
  default = "XXXX"
}
variable "exoscale_api_secret" {
  type = string
  default = "XXXX"
}
provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}

resource "exoscale_sks_cluster" "my_sks_cluster" {
  zone = "ch-gva-2"
  name = "my-sks-cluster"
}

output "my_sks_cluster_endpoint" {
  value = exoscale_sks_cluster.my_sks_cluster.endpoint
}


resource "exoscale_sks_nodepool" "my_sks_nodepool" {
  cluster_id         = exoscale_sks_cluster.my_sks_cluster.id
  zone               = exoscale_sks_cluster.my_sks_cluster.zone
  name               = "my-sks-nodepool"

  instance_type      = "standard.medium"
  size               = 3
}

resource "exoscale_security_group" "my_security_group" {
  name = "my-security-group"
}

resource "exoscale_security_group_rule" "my_security_group_rule" {
  security_group_id = exoscale_security_group.my_security_group.id
  type = "INGRESS"
  protocol = "TCP"
  cidr = "0.0.0.0/0" # "::/0" for IPv6
  start_port = 80
  end_port = 80
}
