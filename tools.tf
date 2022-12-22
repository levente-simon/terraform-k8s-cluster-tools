variable "module_depends_on" {
  type    = any
  default = []
}

# cert-mgr
resource "helm_release" "cert_manager" {
  depends_on       = [ var.module_depends_on ]
  count            = var.enable_cert_mgr ? 1 : 0
  name             = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# longhorn
resource "helm_release" "longhorn" {
  depends_on       = [ var.module_depends_on ]
  count            = var.enable_longhorn ? 1 : 0
  name             = "longhorn"

  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  namespace        = "longhorn"
  create_namespace = true

  values = [ format(file("${path.module}/etc/longhorn-config.yaml"),
                 var.longhorn_data_path,
                 var.longhorn_default_replica_count) ]
}

# metallb
resource "helm_release" "metallb" {
  depends_on       = [ var.module_depends_on ]
  count            = var.enable_metallb ? 1 : 0
  name             = "metallb"

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "metallb"
  namespace        = "metallb"
  create_namespace = true
}


resource "kubernetes_manifest" "ip_address_pool" {
  depends_on = [ helm_release.metallb ]
  count      = var.enable_metallb ? 1 : 0

  manifest   = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "IPAddressPool"
    "metadata" = {
      "name"      = "pool"
      "namespace" =  "metallb"
    }
    "spec" = {
      "addresses" = [ var.metallb_address_pool ]
    }
  }
}

resource "kubernetes_manifest" "l2_advertisement" {
  depends_on = [ helm_release.metallb ]
  count      = var.enable_metallb ? 1 : 0

  manifest   = {
    "apiVersion" = "metallb.io/v1beta1"
    "kind"       = "L2Advertisement"
    "metadata" = {
      "name"      = "l2adv"
      "namespace" = "metallb"
    }
    "spec" = {
      "ipAddressPools" = [ "pool" ]
    }
  }
}

# external-dns
resource "helm_release" "external_dns" {
  depends_on       = [ var.module_depends_on ]
  count            = var.enable_external_dns ? 1 : 0
  name             = "external-dns"

  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  values = [ format(file("${path.module}/etc/external-dns-config.yaml"),
                 var.dns_server,
		 var.dns_port,
		 var.searchdomain) ]
}


