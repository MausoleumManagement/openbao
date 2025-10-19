## Setting up external secrets operator to work with oepnbao

This was mostly according to this [blog post](https://blog.container-solutions.com/tutorialexternal-secrets-with-hashicorp-vault), with some adjustments for the current state of things.


First we apply the policy we wrote for the external secrets operator
```bash
bao policy write nekropolis-ro policies/external-secrets-nekropolis.hcl
```

The `kubernetes` authentication method needs to be activated so that the external secrets operator can authenticate using its service account
```bash
bao auth enable kubernetes
```

Openbao needs to use the TokenReview-API provided by the API-Server to determine whether a given pod's ServiceAccount Token is valid. It uses its own ServiceAccount Token to talk to the API-Server for that.
- We omit the `token_reviewer_jwt` parameter in the kubernetes auth method, because we want to use the funny short lived tokens that are all the rage now. That way, openbao will just grab its own Service Account token, which is located under the default path for each pod, and gets automatically rotated. If we explicitly set `token_review_jwt`, we would have to use a long lived token and that is just not fashionable anymore. See [the docs](https://openbao.org/docs/auth/kubernetes/#use-local-service-account-token-as-the-reviewer-jwt) for more info.
- Disabling issuer validation is recommended. The `issuer` field for a token can vary based on the cluster configuration. Whether the token is signed by the cluster CA is still validated, so this prevents unnecessary breakage.
```bash
k8s_host="$(kubectl -n openbao exec openbao-0  -- printenv | grep KUBERNETES_PORT_443_TCP_ADDR | cut -f 2- -d "=" | tr -d " ")"
k8s_port="443"            
k8s_cacert="$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)"

bao write auth/kubernetes/config kubernetes_host="https://${k8s_host}:${k8s_port}" kubernetes_ca_cert="${k8s_cacert}" disable_issuer_verification=true
```

If we want to read, what we just configured:
```bash
bao read auth/kubernetes/config
```



Next we define a role that gets applied to any vault tokens issued to Pods that fulfill the criteria we specify for the SA name and namespace. I.e. if you are a pod that has the external-secrets service account, you get to see what's inside the kv engine.
```
bao write auth/kubernetes/role/nekropolis-external-secrets \
    bound_service_account_names=external-secrets \
    bound_service_account_namespaces=external-secrets \
    policies=nekropolis-ro \
    ttl=24h
```

And that's all, the rest needs to be configured inside the external secrets operator
