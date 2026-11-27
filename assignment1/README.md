# Assignment 1

# capture environments.json
Create envs in gh:
![environments](evidence/environments.png)
After creating envs in github, needed `gh api repos/lululeon/acs730-01/environments/prod/deployment-branch-policies`. Saved [here](./evidence/environments.json).

# fix staging pipeline:
Getting this error:
![staging error](./evidence/staging-error.png)
Need to run `terraform state rm 'module.web.aws_s3_bucket.artifacts'`

Then had to cancel the workflow, and then rerun. Staging now completes, and prod waits for manual intervention:
![prod wait](./evidence/prod-approval-pending.png)

# moving the secrets:
- used: `./scripts/refresh-gha-creds.sh lululeon/acs730-01 staging prod`
- then deleted **repo-level** vars: `gh api repos/lululeon/acs730-01/actions/secrets` returns:
```json
{
  "total_count": 0,
  "secrets": []
}
```

Used this for secrets-scope.txt:
```sh
gh secret list --repo lululeon/acs730-01 > assignment1/evidence/secrets-scope.txt
echo "=== staging ===" >> assignment1/evidence/secrets-scope.txt
gh secret list --repo lululeon/acs730-01 --env staging >> assignment1/evidence/secrets-scope.txt
echo "=== prod ===" >> assignment1/evidence/secrets-scope.txt
gh secret list --repo lululeon/acs730-01 --env prod >> assignment1/evidence/secrets-scope.txt
```

# recording staging-apply.txt, prod-apply.xt
used: `gh run view <run-id> --repo lululeon/acs730-01 > assignment1/evidence/staging-apply.txt` etc

approval:
![approval dialog](./evidence/approval-dialog.png)

see runs in [staging-apply](./evidence/staging-apply.txt) and [prod-apply](./evidence/prod-apply.txt).

# checks in AWS
![vpcs](./evidence/vpcs.png)
![instances](./evidence/instances.png)
![cloudwatch alarm](./evidence/cloudwatch-alarm.png)
