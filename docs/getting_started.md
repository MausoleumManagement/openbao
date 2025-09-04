Wenn eine Openbao-Instanz installiert wird, ist sie zunaechst uninitialisiert. Damit wir mit ihr arbeiten koennen, muessen wir [den Initialisierungsprozess](https://openbao.org/docs/commands/operator/init/) absolvieren.



Falls wir mehr Heckmeck beim Entsiegeln haben wollen
```
k -n openbao exec -it openbao-0 -- bao operator init \
    -key-shares=5 \
    -key-threshold=3 \
    -format=json > cluster-keys.json
```

Wenn wir ehrlich mit uns sind ...
```
k -n openbao exec -it openbao-0 -- bao operator init \
    -key-shares=1 \
    -key-threshold=1
```


```
k -n openbao exec -it openbao-0 -- bao operator unseal


k -n openbao exec -it openbao-1 -- bao operator raft join http://openbao-0.openbao-internal:8200
k -n openbao exec -it openbao-1 -- bao operator unseal

k -n openbao exec -it openbao-2 -- bao operator raft join http://openbao-0.openbao-internal:8200
k -n openbao exec -it openbao-2 -- bao operator unseal
```


## Lektuere

- https://openbao.org/docs/platform/k8s/helm/examples/ha-with-raft/
