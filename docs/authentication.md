
Login using a token
```
bao login username=root
```

Login using  username/pw
```
bao login -method=userpass username=admin
```

Create a Token for the currently logged in user. By default, tokens inherit the users policies, unless we explicitly define a subset of policies
``` 
bao token create -ttl=120d -policy=POLICY -display-name=TOKENNAME
```
