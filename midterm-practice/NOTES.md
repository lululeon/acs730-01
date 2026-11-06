# Midterm Practice -- Notes

Initial failures:
![initial failures](evidence/image.png)
Switched to working locally
![local fail](evidence/image-2.png)

## Local Build fails:
![local build failure](evidence/image-1.png)
![cannot reach](evidence/image-3.png)
![terraform-failure](evidence/image-5.png)
![tf plan failure](evidence/image-7.png)

## Fixes implemented:
- update dockerfile to get requirements first.
- fix the bind port
- fix correct use of foreach key: `aws_subnet.public[each.key].id`
- similar fix for ingress ports: plurality: `for_each = var.ingress_ports`
- ci file: correct path to app

fixed healthcheck
![fixed curl healthcheck](evidence/image-4.png)

fixed tf validate
![validate fixed](evidence/image-6.png)


## Task 5: git hygiene

Delete the tfstate file does not suffice because it will be there in git history. The history for the project would need to be rebuilt.

