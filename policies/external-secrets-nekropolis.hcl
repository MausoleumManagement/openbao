path "kv/data/nekropolis/*" {
  capabilities = ["read"]
}

path "kv/metadata/nekropolis/*" {
  capabilities = ["list", "read"]
}
