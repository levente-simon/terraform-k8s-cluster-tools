terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

provider "kubernetes" {
  host                   = var.k8s_host
  client_certificate     = var.k8s_client_certificate
  client_key             = var.k8s_client_key
  cluster_ca_certificate = var.k8s_cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    client_certificate     = var.k8s_client_certificate
    client_key             = var.k8s_client_key
    cluster_ca_certificate = var.k8s_cluster_ca_certificate
  }
}

provider "kubectl" {
  host                   = var.k8s_host
  client_certificate     = var.k8s_client_certificate
  client_key             = var.k8s_client_key
  cluster_ca_certificate = var.k8s_cluster_ca_certificate
  load_config_file       = false
}