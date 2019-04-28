```
aws eks update-kubeconfig --name `jx get eks | grep -v NAME| cut -f 1`
```



jx install --git-provider-url='https://bitbucket.org/' --git-api-token=$GIT_TOKEN --default-admin-password=$ADMIN_PASS --provider=eks --domain=$ROUTE53_DOMAIN --git-private=true  --default-environment-prefix=datalakedev --git-username=$GIT_USER --environment-git-owner=$GIT_OWNER
--no-tiller
