# particle41-DevOps

### Directory Structure

---

#### HTTP WebServer
1. Folder: /SimpleTimeService
2. Language: Golang
3. Build version: go1.23.4 windows/amd64
4. lib/reference: references.txt

---

#### Dockerfile
1. Folder: /SimpleTimeService/Dockerfile
2. Build version (image): golang:1.25-alpine
3. Approach: Used Multi-Stage Build

---

#### Docker Commands
1. cd /SimpleTimeService
2. docker build -D -t a7ryan/simpleTimeService:v1 .
3. docker push a7ryan/simpleTimeService:v1
4. docker run --name=simpleTimeService -d -p 8080:8080 a7ryan/simpleTimeService:v1
5. (Testing URL): http://localhost:8080

---

#### DockerHub
1. Image Repo: a7ryan/simpleTimeService
2. Clone Image: docker pull a7ryan/simpleTimeService:v1
3. Run Container: docker run --name=simpleTimeService -d -p 8080:8080 a7ryan/simpleTimeService:v1