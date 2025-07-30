FROM felddy/foundryvtt:13

# Install OpenSSH
USER root
RUN apt-get update && \
    apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Create privilege separation directory for SSH
RUN mkdir -p /run/sshd

# Create an SSH user (non-root)
RUN adduser --disabled-password --gecos "" foundry && \
    mkdir -p /home/foundry/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBXxUTYlsytb0eDSzU3ZCoUxSgpbZuYmAlN2U/9OmFp r7@lumina" > /home/foundry/.ssh/authorized_keys && \
    chown -R foundry:foundry /home/foundry/.ssh && \
    chmod 700 /home/foundry/.ssh && \
    chmod 600 /home/foundry/.ssh/authorized_keys

# Harden SSH
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "AllowUsers foundry" >> /etc/ssh/sshd_config

# Expose both Foundry and SSH ports
EXPOSE 30000 22

# Use CMD to run OpenSSH alongside Foundry
CMD ["/usr/sbin/sshd", "-D"]
