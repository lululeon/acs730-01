# Lab 6

## points raised in lab:

### No runner address anywhere in the workflow
They don't normally address the runner; not sure why this workflow would be any different. Each run is a fresh vm and the workflow only says what type of runner it wants (`runs-on: ubuntu-latest`).

### The tooling goes in near the top, not between apply and converge.
We don't want the newly provisioned infrastructure hanging around for too long before convergence; that would be an opportunity for out of band changes (someone else running an apply, manual edits that could introduce changes etc): these could change expected conditions found by ansible and ultimately change what convergence does. This in turn can destroy idempotency. 

It's best to prevent that by running convergence as soon as possible after apply.

### session-manager-plugin is installed explicitly
The runner does not have software / plugins installed locally and it also does not have anything available in aws. So all needed tools must be explicitly installed.

### The retry loop before the playbook
This emulates what was done locally to allow hosts time to bootup and connect with SSM Manager before going any further (otherwise the convergence step can fail)


