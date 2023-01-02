variable "k8s_host" { type = string }
variable "k8s_client_certificate" {
  type      = string
  sensitive = true
}
variable "k8s_client_key" {
  type      = string
  sensitive = true
}
variable "k8s_cluster_ca_certificate" {
  type      = string
  sensitive = true
}

variable "enable_cert_mgr" {
  type    = bool
  default = true
}
variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}

variable "enable_longhorn" {
  type    = bool
  default = true
}
variable "longhorn_namespace" {
  type    = string
  default = "longhorn-system"
}

variable "longhorn_data_path" {
  type    = string
  default = "/data/longhorn"
}
variable "longhorn_default_replica_count" {
  type    = number
  default = 3
}

variable "enable_metallb" {
  type    = bool
  default = true
}
variable "metallb_namespace" {
  type    = string
  default = "metallb"
}
variable "metallb_address_pool" {
  type    = string
  default = "127.0.0.2-127.0.0.100"
}

variable "enable_external_dns" {
  type    = bool
  default = true
}
variable "external_dns_namespace" {
  type    = string
  default = "external-dns"
}
variable "dns_server" {
  type    = string
  default = "127.0.0.1"
}
variable "dns_port" {
  type    = string
  default = "53"
}
variable "searchdomain" {
  type    = string
  default = ""
}
