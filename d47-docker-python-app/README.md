## Dockerizing Python App

**Server:** App Server 3 (Stratos DC)
**Directory:** `/python_app/`
**Image name:** `nautilus/python-app`
**Container name:** `pythonapp_nautilus`

---

### ⚙️ Step-by-Step Implementation

#### 1️⃣ Go to the project directory

```bash
cd /python_app/
```

#### 2️⃣ Create the Dockerfile

Create and edit the file:

```bash
sudo vi Dockerfile
```

Add the following content:

```dockerfile
# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements.txt
COPY src/requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY src/ .

# Expose port 5000
EXPOSE 5000

# Run the application
CMD ["python", "server.py"]
```

---

#### 3️⃣ Build the Docker image

```bash
sudo docker build -t nautilus/python-app .
```

Expected output (summary):

```
Successfully built <image_id>
Successfully tagged nautilus/python-app:latest
```

---

#### 4️⃣ Run the container

```bash
sudo docker run -d --name pythonapp_nautilus -p 8093:5000 nautilus/python-app
```

Verify it’s running:

```bash
sudo docker ps
```

Expected:

```
CONTAINER ID   IMAGE                COMMAND             STATUS         PORTS                    NAMES
xxxxx          nautilus/python-app  "python server.py"  Up xx seconds  0.0.0.0:8093->5000/tcp   pythonapp_nautilus
```

---

#### 5️⃣ Validate the app

```bash
curl http://localhost:8093/
```

Expected output (example):

```
Welcome to Nautilus Python App!
```

---

### ✅ Final Verification

| Component      | Status                                          | Details |
| -------------- | ----------------------------------------------- | ------- |
| **Dockerfile** | ✅ Created under `/python_app/`                  |         |
| **Image**      | ✅ `nautilus/python-app` built successfully      |         |
| **Container**  | ✅ `pythonapp_nautilus` running                  |         |
| **Ports**      | ✅ Host `8093` → Container `5000`                |         |
| **App check**  | ✅ `curl localhost:8093` returned valid response |         |

---
