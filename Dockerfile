FROM felddy/foundryvtt:13

# Install OpenSSH
USER root
RUN apk add --no-cache openssh

# Create an SSH user (non-root)
RUN adduser -D foundry && \
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

# Start both processes with supervisord or custom script
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]