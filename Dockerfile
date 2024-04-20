# We use the latest Rust stable release as base image
FROM rust:1.77.2 as builder

WORKDIR /app
# Install the required system dependencies for our linking configuration
# Copy all files from our working environments to our Docker image
# Build binary!
# Using release profile to make it fast
RUN apt update && apt install lld clang -y && \
    COPY . . && \
    ENV SQLX_OFFLINE true && \
    cargo build --release

# Use a smaller base image for the final image
FROM debian:buster-slim
WORKDIR /app
COPY --from=builder /app/target/release/newsletter /app/newsletter
# When `docker run` is executed, launch the binary!
ENTRYPOINT [ "./newsletter" ]