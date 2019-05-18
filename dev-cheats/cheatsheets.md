```
aws eks update-kubeconfig --name `jx get eks | grep -v NAME| cut -f 1`
```

```

aws iam list-roles \
    | jq -r ".Roles[] \
    | select(.RoleName \
    | startswith(\"$AWS_CLUSTER_NAME\") and contains(\"NodeInstanceRole\")) \
    .RoleName"
```
