# oidc trust policy
This was used as ref: [gh oidc](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws)

So the relevant trust policy would look like this:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::111122223333:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": "repo:lululeon/acs730-01:environment:prod"
                }
            }
        }
    ]
}


```

- The **sub** claim resricts it to only the prod environment of this specific repo.
- The **aud** claim shows that amazon STS (secure token service) is the audience: when Github connects to AWS, it is specifically connecting to STS to obtain the necessary shortlived tokens.

This approach is not being used because apparently aws academy restricts creation of the oidc provider & role.

# ssm param command (put-parameter)
this was created out of band (not via terraform; terraform reads it in a data block). Command format:

```sh
aws ssm put-parameter \
  --name /acs730/assn1/db_password \
  --value 'xxxxx' \
  --type SecureString \
  --overwrite
```

which returned:
```json
{
    "Version": 1,
    "Tier": "Standard"
}
```