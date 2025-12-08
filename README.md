# particle41-DevOps


#### Working Output

1. Browser Output

![Browser Output](https://github.com/A7ryan/particle41-DevOps/blob/main/images/browser-output.png)

2. Health Check

![Health Check](https://github.com/A7ryan/particle41-DevOps/blob/main/images/browser-health-check.png)


---

### Purpose of the Project

- Build and containerize Golang webserver
- Push image to DockerHub
- Provision AWS infrastructure using Terraform: 
- A VPC with public and private subnets
- An EKS cluster deployed into private subnets
- An AWS Load Balancer in public subnets
- Deploy the application automatically to EKS using Terraform
- <b>Main Aim:</b> anyone can run this using `terraform plan` and `terraform apply`.
---

# Clone the Repo

## <b>`git clone https://github.com/A7ryan/particle41-DevOps.git`</b>


### Directory Structure

---

#### Golang - HTTP WebServer

- Install Go - `https://go.dev/doc/install`

1. Folder: /SimpleTimeService
2. Language: Golang
3. Build version: go1.23.4 windows/amd64
4. lib/reference: references.txt
5. Run/test code local pc: 
- `cd ./SimpleTimeService`
- `go mod init <your-github-username>/golang-webserver`
- `go mod tidy`
- `go run main.go`

---

#### Dockerfile

- Install Docker: `https://www.docker.com/get-started/`

1. Folder: /SimpleTimeService/Dockerfile
2. Build version (image): golang:1.25-alpine
3. Approach: Used Multi-Stage Build

---

#### Docker Commands
1. `cd ./SimpleTimeService`
2. `docker build -D -t a7ryan/simple-time-service:latest .`
3. `docker push a7ryan/simple-time-service:latest`
4. `docker run --name=simpleTimeService -d -p 8080:8080 a7ryan/simple-time-service:latest`
5. (Testing URL): http://localhost:8080

---

#### DockerHub
1. Image Repo: a7ryan/simple-time-service
2. Clone Image: `docker pull a7ryan/simple-time-service:latest`
3. Run Container: `docker run --name=simpleTimeService -d -p 8080:8080 a7ryan/simple-time-service:latest`

---

#### Terraform Prerequsites

- Configure: AWS-CLI, Git and Terraform (see last)
- <b>NOTE: If you do not setup all 3 tools, terraform will not work</b>
- Install: `choco install terraform`
- My version: Terraform v1.10.4
- Code compatible even with latest version: 1.14.1.
- Folder: /Terraform

---

#### Terraform Commands
1. `cd ./Terraform`
2. `terraform init`
3. `terraform validate`
4. `terraform plan`
5. `terraform apply`

- It will take around 10 mins..
- Once process is finished you will get below output:

![Terraform Output](https://github.com/A7ryan/particle41-DevOps/blob/main/images/terraform-output.png)

- Paste the application_url into your browser to access the webservice.
- <b>NOTE:</b> use http://<application_url>
- Do not use https
- It will show output as: ![Result](https://github.com/A7ryan/particle41-DevOps/blob/main/README.md#working-output)
- Finally conclusion:  `terraform destroy`


---

#### AWS Configure
- Run in terminal: 
`aws configure`
- Enter your account details (IAM Access Key)
- Choose region: `us-east-1`
- NOTE: I have used IAM User with `AdministratorAccess Policy` (and not Root user) for this demo.
- Not best practice but for testing/dev the IAM with Admin access would work.

---

#### Git Install
- Run in terminal:
`https://git-scm.com/install/`
