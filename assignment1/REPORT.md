# Introduction

Assignment 1 takes the Week 7 Terraform stack and turns it into a reusable module called from three environments (`dev`, `staging`, `prod`), each with its own S3 state key. A merge to `main` starts the GitHub Actions deploy for staging and prod. Staging applies on its own. Prod waits for a reviewer under a GitHub Environment protection rule. AWS Academy credentials are stored as environment secrets and refreshed each lab session. The sections below cover the OIDC trust policy we would use outside Academy, the SSM parameter Terraform reads, the CloudWatch alarm, and a recommendation on GitHub Actions versus an AWS-native pipeline.

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

- The **sub** claim resricts it to only the prod environment of this specific repo. Only a workflow job that runs with `environment: prod` can assume this role. A subject like `repo:lululeon/acs730-01:*` would let a job from any ref or environment on the repo assume it, including someone who can push a workflow on a feature branch.
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

for evidence without printing secret:
```sh
aws ssm get-parameter \
  --name /acs730/assn1/db_password \
  --query 'Parameter.{Name:Name,Type:Type,Version:Version,LastModifiedDate:LastModifiedDate}' \
  > assignment1/evidence/ssm-parameter.txt
```

# cloudwatch alarms
generated with: `aws cloudwatch describe-alarms --alarm-name-prefix acs730 > assignment1/evidence/cloudwatch-alarm.json`

# Recommendation

I would still recommend **GitHub Actions** for a team that is committed to AWS and has no multi-cloud plans.

Hosted runners mean the team does not have to patch or scale the machines that run CI. People can stay on application and Terraform work. If a job needs to reach something only available on a private network, you can attach self-hosted runners there and keep the same workflow files and Environment approval gates. The delivery path also stays less tied to a single AWS account’s CodePipeline/CodeBuild setup, which helps if account layout or tooling changes later.

The main tradeoff is identity. GitHub needs a way into AWS, which would be via OIDC (more robust), rather than the session-scoped secrets we used here. Those trust policies also need to be written very carefully (`sub` scoped to `environment:prod`).

I would only propose an AWS-native pipeline if the org is already heavily invested in AWS and the team is already good at owning that infra, including whatever runs the builds. In that scenario, build roles are seamlessl tied to aws IAM roles, and the extra OIDC bridging goes away.

# Conclusion

The useful part of this assignment was making promotion rules and credentials match the environment they protect: separate state keys, Environment secrets, and a prod approval gate. SSM and the CloudWatch alarm were small Terraform pieces, but they forced good habits — create the secret out of band, and wait until the alarm has a real state before capturing evidence. Going forward I would keep that environment-shaped boundary even when the pipeline tooling changes.
