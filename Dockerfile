# Stage 1: Build stage
FROM hashicorp/tfc-agent AS builder

# Switch to root user to install packages
USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip

COPY awscliv2.zip .

RUN unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws

USER tfc

FROM hashicorp/tfc-agent
COPY --from=builder /usr/local/bin/aws /usr/local/bin/aws
ENV PATH="/usr/local/bin/aws:${PATH}"
RUN apt-get clean
    # rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/local/bin/tfc-agent"]
