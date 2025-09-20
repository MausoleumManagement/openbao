Wenn eine Openbao-Instanz installiert wird, ist sie zunaechst uninitialisiert. Damit wir mit ihr arbeiten koennen, muessen wir [den Initialisierungsprozess](https://openbao.org/docs/commands/operator/init/) absolvieren.




## Initialisierung

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

Neben dem Schluessel zum Entsiegeln wird auch ein Initialtoken ausgegeben, mit dem wir uns authentifizieren koennen. Siehe unten unter **Authentifizierung**.


## Raft Setup Prozedur

```
k -n openbao exec -it openbao-0 -- bao operator unseal


k -n openbao exec -it openbao-1 -- bao operator raft join http://openbao-0.openbao-internal:8200
k -n openbao exec -it openbao-1 -- bao operator unseal

k -n openbao exec -it openbao-2 -- bao operator raft join http://openbao-0.openbao-internal:8200
k -n openbao exec -it openbao-2 -- bao operator unseal
```

## HA Postgres (CNPG) Setup Prozedur

```
k -n openbao exec -it openbao-0 -- bao operator unseal

k -n openbao exec -it openbao-1 -- bao operator unseal

k -n openbao exec -it openbao-2 -- bao operator unseal
```

## Authentifizierung

Mittels des vorgenerierten root-Tokens koennen wir uneingeschraenkt arbeiten, deswegen wird empfohlen, dieses alsbald zu entwerten.
```
k -n openbao exec -it openbao-0 -- sh
bao login token=abc123
```


Um Passwort-Authentifizierung zu ermoeglichen,  muessen wir die entsprechende Methode zunaechst einschalten:
```
bao auth enable userpass
```

Das vorherige Kommando gibt den API-Pfad zurueck, unter dem die neue Methode aktiviert wird:

```
Success! Enabled userpass auth method at: userpass/
```

Im Anschluss koennnen wir im entsprechenden API-Pfad einen Eintrag mit dem Namen admin anlegen, und desen Inhalt kann dann zur Authentifizierung genutzt werden.
```
bao write auth/userpass/users/admin \
    password=abc123 \
    policies=admins
```
