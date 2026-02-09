# 🛒 MyShop – Three-Tier E-commerce System

## 1. Project Overview

**MyShop** is a personal project that simulates a real-world e-commerce system designed using a **Three-Tier Architecture**.  
The project focuses on applying **DevOps best practices**, from application design to infrastructure provisioning using **Infrastructure as Code (Terraform)**.

The goal is not only to build a working web application, but also to demonstrate:
- System design thinking
- Scalability and separation of concerns
- Production-ready DevOps workflow

---

## 2. Project Goals

- Design a **stateless, scalable web application**
- Clearly separate **Presentation, Application, and Data layers**
- Use **SQL and NoSQL** databases for appropriate workloads
- Containerize the application for consistent deployment
- Provision cloud infrastructure using **Terraform**
- Prepare the system for future CI/CD and scaling

---

## 3. High-Level Architecture (Logical)

```
[ Frontend (React) ]
          |
[ Backend API (Node.js / Express) ]
          |
[ Data Layer ]
   - PostgreSQL (SQL)
   - Redis / DynamoDB (NoSQL)
```

---

## 4. Technology Stack

### Frontend (Presentation Tier)
- React (Vite)
- React Router DOM
- REST API communication
- Stateless UI

### Backend (Application Tier)
- Node.js
- Express.js
- CORS
- JWT-based authentication
- RESTful API design

### Data Layer
- PostgreSQL (SQL)
- Redis / DynamoDB (NoSQL)

---

## 5. Project Structure

```bash
myshop/
├── frontend/
├── backend/
├── docker-compose.yml
├── infra/
└── README.md
```

---

## 6. Project Phases


### Phase 1 – Requirements & Design **(Completed)**
Define scope, architecture, and database schema.

### Phase 2 – Backend Development **(Completed)**
Build REST APIs, authentication, cart, and order logic.

### Phase 3 – Frontend Development **(Completed)**
Implemented UI and API integration. 

### Phase 4 – Containerization **(Completed)**
Dockerized frontend and backend using Docker Compose. 

### Phase 5 – Infrastructure as Code
Provision AWS infrastructure using Terraform.

### Phase 6 – Deployment & Scaling
Deploy to AWS and enable auto-scaling.

### Phase 7 – Monitoring & Optimization
Add monitoring, logging, and alerts.

---

## 7. Portfolio Focus

This project demonstrates end-to-end DevOps thinking, clean architecture, and infrastructure automation.
