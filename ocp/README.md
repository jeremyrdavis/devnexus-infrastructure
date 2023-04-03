# OCP

# ConfigMap
kubectl create configmap my-config --from-literal=greeting="Hello, ConfigMap!" \
    --from-literal=JDBC_URL=jdbc:postgresql://localhost:5432/devnexus \
    --from-literal=JDBC_DRIVER=org.postgresql.Driver \
    --from-literal=JDBC_USER=devnexususer \
    --from-literal=JDBC_PASSWORD=devnexus20232isawesome \
    --from-literal=HIBERNATE_LOG_SQL=true \
    --from-literal=QUARKUS_LOG_LEVEL=INFO

# Docker
docker buildx build --platform linux/amd64,linux/arm64 -f src/main/docker/Dockerfile.jvm -t dnacr.azurecr.io/devnexus/devnexus01:v2 .