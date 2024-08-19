# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for adding new repositories
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    curl \
    wget \
    vim \
    git \
    sudo \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    ca-certificates \
    git \
    openssh-server \
    iputils-ping \
    coreutils\
    systemd \
    systemd-sysv \
    dbus \
    dbus-user-session\
    && rm -rf /var/lib/apt/lists/*

# # Add deadsnakes PPA to get the specific Python version
# RUN add-apt-repository ppa:deadsnakes/ppa

# # Update the package lists and install necessary packages
# RUN apt-get update && \
# apt-get install -y \
# python${PYTHON_VERSION} \
# python${PYTHON_VERSION}-dev \
# python${PYTHON_VERSION}-distutils \
# python${PYTHON_VERSION}-venv \
# && rm -rf /var/lib/apt/lists/*
 
# # Set the default Python version
# RUN update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1
 
# # Set the default Python version for pip
# RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip${PYTHON_VERSION} 1
 
# # Verify the Python installation
# RUN python --version && \
#     pip --version

# Create a new user named ${USERNAME} and set a password
RUN useradd -m -s /bin/bash "${USERNAME}" --badname
RUN echo "${USERNAME}:password" | chpasswd

# Add ${USERNAME} to sudoers without password
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/coder

# Change to ${USERNAME}
USER ${USERNAME}

# Configure Git user
RUN git config --global user.name "${GIT_USERNAME}"
RUN git config --global user.email "${GIT_EMAIL}"

# Create a directory for code-server extensions
RUN mkdir -p /home/${USERNAME}/.local/share/code-server/extensions

# Install VSCode Server along with python and jupyter extensions, insert yours here
RUN curl -fsSL https://code-server.dev/install.sh | sh && \
    code-server --install-extension ms-python.python && \
    code-server --install-extension ms-toolsai.jupyter


# Expose ports for SSH and code-server
EXPOSE 8080 22

# Start SSH service and code-server on container startup
CMD sudo service ssh start && code-server --auth none --bind-addr 0.0.0.0:8080
