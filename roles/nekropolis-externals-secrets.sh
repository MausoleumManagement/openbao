bao write auth/kubernetes/role/nekropolis-external-secrets \
    bound_service_account_names=external-secrets \
    bound_service_account_namespaces=external-secrets \
    policies=nekropolis-ro \
    ttl=24h
