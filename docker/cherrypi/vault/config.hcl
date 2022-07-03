storage "file" {
  path    = "vault/file"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = "true"
}

disable_mlock = true

ui = true

cluster_name = "vault-transit"