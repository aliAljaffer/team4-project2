# Project 2 - Three-tier app on Azure with fully automated deployment

Repo structure:

```
.
├── ansible
├── backend
├── frontend
├── terraform-all
└── terraform-sonarqube
```

The main goal is to **fully automate** the deployment of a three-tier web app, from containerization, pushing to a registry (Dockerhub by default), to provisioning the infrastructure required on Azure. This was accomplished using modern tools such as Terraform, Ansible, and Github Actions.

## Team Members

- Ali Aljaffer (Team Lead, Scrum Master) [github/alialjaffer](https://github.com/aliAljaffer)
- Rashid Alharbi (DevOps Engineer) [github/Rashid0029](https://github.com/Rashid0029)
- Maryam Almusajin (DevOps Engineer) [github/maryamalmusajin](https://github.com/maryamalmusajin)
- Abdulilah Alomrani (DevOps Engineer) [github/Aboodx0191](https://github.com/Aboodx0191)
- Bayan Alzahrani (DevOps Engineer) [github/bayanzh](https://github.com/bayanzh)
- Ahmed Aljohani (DevOps Engineer) [github/lord0q](https://github.com/lord0q)

## App Features

1. Images with commit-based tags. Helps to track changes when using commit hashes as image versions.
2. Secure connections using Private Endpoints for the Database layer and App Services. The only public-facing point-of-contact is the application gateway, which takes care of the pathing.
3. Monitoring and Autoscaling ensure the app will react to the workload it's under.
4. Efficient CI/CD pipelines for Docker images, detecting only what tier was changed and performing the appropriate workflow for it, without creating unnecessary copies of images.
5. Cost-efficient scanning using SonarQube hosted on a VM. This VM is provisioned in case of changes to the frontend or backend code, to assist in the scanning step. The last step of the pipeline is to delete this VM, so it's only available during the pipeline lifecycle.

## Tech Stack

WIP

## Screenshots

WIP

## System Design

WIP

## Challenges

WIP
