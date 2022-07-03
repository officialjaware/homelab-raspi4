storage "file" {
  path    = "vault/file"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = "true"
}

disable_mlock = true

license_path = "vault/config/vault.hclic"

ui = true

cluster_name = "vault"

seal "transit" {
  address = "http://10.0.1.2:8200"
  disable_renewal = "false"
  key_name = "autounseal"
  mount_path = "transit/"
  tls_skip_verify = "true"
}
