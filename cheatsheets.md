```
aws eks update-kubeconfig --name `jx get eks | grep -v NAME| cut -f 1`
```

```
DOMAIN=k8s.xyz.com.au
ENV_PREFIX=xxx
GIT_TOKEN='xxx'
ADMIN_PASS='xyz'
GIT_USER='abc'
GIT_OWNER='pqrs'

jx install --gitops=true --git-provider-url='https://bitbucket.org/' --git-api-token=$GIT_TOKEN --default-admin-password=$ADMIN_PASS --provider=eks --domain=$DOMAIN --git-private=true --ingress-deployment='jxing-nginx-ingress-controller' --default-environment-prefix=$ENV_PROFIX --git-username=$GIT_USER --environment-git-owner=$GIT_OWNER --no-gitops-vault=true
```


