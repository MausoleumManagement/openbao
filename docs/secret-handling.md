
Storing secrets under an entry works by passing them as `key=value` pairs
```bash
bao kv put -mount=kv nekropolis/example-entry abc=123
```

List entries
```bash
bao kv list -mount=kv nekropolis/
```

Retrieve secret values
```bash
bao kv get -mount=kv nekropolis/example-entry
```

Multiple values can be stored under an entry. `put` overwrites  the entry with only the secrets specified remaining

```bash
bao kv put -mount=kv nekropolis/example-entry uvw=111 xyz=789
```


`patch` leaves the unspecified secrets as they are, and modifies the specified values.

```bash
bao kv patch -mount=kv nekropolis/example-entry abc=123 def=456
```

Deleting entries
```
bao kv delete -mount=kv nekropolis/example-entry
```
