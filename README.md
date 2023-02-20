HashiCorp Packer guide
---
The content of this project is part of the post on blog https://red-devops.pl/<br>
The repository includes a workflow that builds a machine image using the HasiCorp Packer tool. The machine image is built and stored on the Amazon AWS cloud. Packer's workflow uses Ansibe provisioner plugin to install the Roles indicated in the Playbook.
The machine image builds a GitHub self-hosted runner.<br> 
A self-hosted registration token is required when triggering the workflow.