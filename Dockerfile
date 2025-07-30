FROM felddy/foundryvtt:13

# Install OpenSSH and Supervisord
USER root
RUN apt-get update && \
    apt-get install -y openssh-server supervisor && \
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

# Configure Supervisord
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose both Foundry and SSH ports
EXPOSE 30000 22

# Start Supervisord to manage both processes
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
