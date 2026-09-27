# Lab 2

# ACS730 Lab 2 

# Step 1 -  Reconnect to workstation

Security group in the earlier instance had been recreated with a new public ip addr (but same private ip as before) was allowing ssh ingress from the static ip used earlier to launch the instance. **manually** replaced the ip with new cidr/32 before notes on sg updates via aws cli. **However, aws-cli was used to create the subsequent security groups for the new instance**.

<details>
  <summary>Details</summary>

  ### identity (re-login)
  ![identity](evidence/identity.png)
</details>


# Step 2 - Custom SSH key pair 
Local keypair created and imported into EC2

<details>
  <summary>Details</summary>

  ### added key
  ![key-creation](evidence/key-create.png)
  ![added key](./evidence/added-key.png)
</details>


# Step 3 - Launch EC2
Created security group locally.
EC2 instance via cli failed - did not attach to SG; created manually.

<details>
  <summary>Details</summary>

  ### Security group `my-sg` created
  ![sg creation](evidence/sg-created.png)
  ![sg ssh ingress](./evidence/sg-ssh.png)
  ![sg http ingress](./evidence/sg-http.png)
  ![sg http ingress](./evidence/new-sg.png)

  ### Instance `lab2web2` attached
  ![new ec2 instance](./evidence/new-ec2.png)
  ![new ec2 instance security group](./evidence/new-ec2-sec.png)

</details>
 

# Step 4 connect & create least privileged user
New acs730 user created.

<details>
  <summary>Details</summary>

  ### user created
  ![user creation](evidence/su.png)
</details>

 

# Step 5 install packages with dnf 
Did not read ahead and _installed manually_. However, the `deploy-web.sh` script was created and used for running the server.
see: [script](scripts/deploy-web.sh).


# Step 6 Deploy the web application with a script 
<details>
  <summary>Details</summary>

  The script was created directly on the newly launched web server.
  This is it being back-propagated for inclusion into the git repo
  ![fetch deploy script for gh](evidence/fetch-script.png)

  **website up**:
  ![website up](evidence/before-restart.png)
</details>


# Step 7 systemd service. 
Created systemd service wrapper to start service after network is ready, as a daemon process.

<details>
  <summary>Details</summary>

  ### systemd service file
  ![systemd unit](evidence/sysd-service.png)

  :point_up: this is where a mistake was made: re-enabled httpd itself, instead of the new `acs730-web` service

</details>
 

# Step 8 reboot test
3 reboots were needed due to certain oversights, but the final reboot test passed.

<details>
  <summary>Details</summary>

  ### stopped server
  ![stopped](evidence/stopped.png)

  ### confusions / missteps

  I thought the 1st restart had failed, but actually I was hitting the old IP address, forgetting that it would have changed.
  Secondly, I realized that the I had "enabled" httpd absent-mindedly, not acs730-web. So although the site was reachable after restart, it was reachable purely because i had enabled httpd.

  ![confusion 1](evidence/confusion.png)

  In the end I had to disable httpd, and then enable acs730-web **without starting it right away**, and then reboot the server as a true test of the service file.

  ![confusion 2](evidence/confusion2.png)

  ### final reboot OK
  ![rebooted](evidence/reboot2.png)

</details>
 

### Addendum: Rebooted (new ip addr) 
Forgot git / gh setup was on workstation and ended session prematurely. Hence, yet another new IP just prior to submit.
[alt text](evidence/ip-at-submission.png)
