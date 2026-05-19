# P11: Containerise and orchestrate an app

For this project, I chose to use the official Docker Voting App as my microservices baseline. Since the main goal is infrastructure management I focused entirely on the system engineering side: containerizing the 5 tiers using Docker Compose for local testing, and then architecture-building and dynamically scaling a production-ready setup inside a Kubernetes cluster.

## Application Architecture

The project is split into 5 different parts (microservices) that talk to each other:
1. **Vote:** The frontend web page where users click to vote built with Python.
2. **Redis:** A fast in-memory queue that collects the votes temporarily so the app doesn't crash if too many people vote at once.
3. **Worker:** A backend service built with .NET that pulls votes from Redis and pushes them into the final database.
4. **DB:** A persistent PostgreSQL database where all the votes are saved safely.
5. **Result:** Another frontend web dashboard built with Node.js that shows the voting results in real-time.

## Step 1: Running it locally with Docker Compose
First, I wanted to make sure everything works locally on my machine. I used Docker Compose to spin up all 5 containers at once without having to install Python, .NET, or databases manually on my Windows.

* Command used: "docker-compose up -d"
* Command used for checking:"docker ps"

### Screenshots:
![Docker Compose Status](./screenshots/docker-ps.png)
![Docker Local Browser](./screenshots/docker-browser.jpg)
![Docker Local Browser](./screenshots/docker-browser-result.jpg)

## Step 2: Migrating and Scaling in Kubernetes
After testing it locally, I moved the whole infrastructure into a local Kubernetes cluster using Docker Desktop. I applied all the YAML configuration files from the "k8s-specifications/" folder.

### Key Implementations:
1. **Scaling the Frontend (High Availability):** The original files only start 1 instance of the vote webpage. To make sure the site stays up even under heavy traffic, I manually scaled the "vote" deployment up to 3 replicas running in parallel. 
   * Command I ran: `kubectl scale deployment/vote --replicas=3`
2. **Health Checks (Liveness & Readiness Probes):** 
   * I verified the `readinessProbe` which stops users from accessing the webpage while the Python app is still loading in the background (prevents 502 errors).
   * I verified the `livenessProbe` which tells Kubernetes to automatically kill and restart a container if it freezes or crashes (Self-Healing).
3. **Fixing the Ports (Port Forwarding):** Since Windows networks can be tricky with Kubernetes NodePorts, I used `kubectl port-forward` to open up direct tunnels to my browser.

Running `kubectl get pods` shows that Kubernetes successfully deployed everything, and it can be seen clearly **3 separate pods running for the vote service** at the same time:
![Kubernetes Active Pods](./screenshots/pods.png)

And here are the final screenshots showing that I can open both the voting page and the results page in my browser directly from the Kubernetes cluster:
![Kubernetes Web Verification](./screenshots/k8s-vote.jpg)
![Kubernetes Results Dashboard](./screenshots/k8s-result.jpg)

## How to run the project
If you want to replicate and test this deployment on your local Kubernetes cluster (Docker Desktop), follow these steps:
1. Apply all the multi-tier microservices and network configurations to your cluster:
`kubectl apply -f k8s-specifications/`
2. Scale the voting application to 3 active replicas for high availability:
`kubectl scale deployment/vote --replicas=3`
3. Verify Pods Status
`kubectl get pods`
4. Access the Interfaces via Port-Forwarding
voting app:`kubectl port-forward svc/vote 31000:8080`
result page: `kubectl port-forward svc/result 31001:80`