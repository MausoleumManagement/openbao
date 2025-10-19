## Reading Material
- https://openbao.org/api-docs/auth/userpass/



```bash
bao policy list

# get info on specified policy
bao policy read default



# figure out what policy is needed for a given action
# using -output-policy
bao  list -output-policy kv/nekropolis


# crete a new policy
bao policy write admin /tmp/policy.hcl


# list users
bao list auth/userpass/users


# create a new user
# this assumes, that the userpass method was activated under  auth/userpass
bao write auth/userpass/users/<USERNAME> \
    password=PASSWORD \
    policies=admins


# update policies associated with a user
bao write auth/userpass/users/<USERNAME>/policies token_policies="policy1,policy2"
