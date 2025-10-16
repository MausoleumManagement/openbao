# Allow mounting secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "update", "delete", "read", "list"]
}
# Allow reading/writing policies for user management
path "sys/policy/*" {
  capabilities = ["create", "update", "delete", "read", "list"]
}
# Allow reading and writing secrets in the kv engine
path "kv/*" {
  capabilities = ["create", "update", "delete", "read", "list"]
}
