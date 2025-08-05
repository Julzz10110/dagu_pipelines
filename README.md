## Quick Start

### 1. Install dagu

**npm**:
```bash
# Install via npm
npm install -g dagu
```

**Homebrew**:

```bash
brew install dagu-org/brew/dagu

# Upgrade to latest version
brew upgrade dagu-org/brew/dagu
```

**macOS/Linux**:

```bash
# Install via script
curl -L https://raw.githubusercontent.com/dagu-org/dagu/main/scripts/installer.sh | bash
```

**Docker**:

```bash
docker run --rm \
  -v ~/.dagu:/var/lib/dagu \
  -p 8080:8080 \
  ghcr.io/dagu-org/dagu:latest \
  dagu start-all
```

Note: see [documentation](https://docs.dagu.cloud/getting-started/installation) for other methods.

### 2. Create your first workflow

```bash
cat > ./hello.yaml << 'EOF'
steps:
  - name: hello
    command: echo "Hello from Dagu!"
  - name: world  
    command: echo "Running step 2"
EOF
```

### 3. Run the workflow

```bash
dagu start hello.yaml
```

### 4. Check the status and view logs

```bash
dagu status hello
```

### 5. Explore the Web UI

```bash
dagu start-all
```

Visit http://localhost:8080

## Docker-Compose

Dagu supports running multiple services in high-availability (HA) mode. 

### 1. Create a `compose.yml` file in your project directory.

```yaml
services:
  dagu-1:
    image: ghcr.io/dagu-org/dagu:latest
    volumes:
      - ./dagu:/var/lib/dagu
    environment:
      - DAGU_COORDINATOR_PORT=50055
    ports:
      - 8080:8080
      - 50055:50055
    command: ["dagu", "start-all"]

  dagu-2:
    image: ghcr.io/dagu-org/dagu:latest
    volumes:
      - ./dagu:/var/lib/dagu
    environment:
      - DAGU_COORDINATOR_PORT=50056 # Use a different port for the second instance
    ports:
      - 8081:8080
      - 50056:50056
    command: ["dagu", "start-all"]

volumes:
  dagu:
    driver: loc