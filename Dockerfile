FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tehran
ENV TERM=xterm-256color
ENV HOME=/root

# Base packages
RUN apt-get update && apt-get install -y \
    curl wget git vim nano htop \
    python3 python3-pip \
    php php-cli \
    build-essential \
    unzip zip \
    sudo tzdata ca-certificates \
    openssh-server \
    tini \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.js 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install wetty (web terminal - much more stable than ttyd)
RUN npm install -g wetty

# Setup root user
RUN echo 'root:root123' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Setup bashrc
RUN echo 'export PS1="\[\e[1;31m\][\u@vps \W]\$\[\e[0m\] "' >> /root/.bashrc \
    && echo 'alias ll="ls -la"' >> /root/.bashrc \
    && echo 'alias cls="clear"' >> /root/.bashrc \
    && echo 'echo ""' >> /root/.bashrc \
    && echo 'echo "  ╔══════════════════════════════╗"' >> /root/.bashrc \
    && echo 'echo "  ║   Welcome to Arvin VPS 🚀    ║"' >> /root/.bashrc \
    && echo 'echo "  ║   /root/main/arvin           ║"' >> /root/.bashrc \
    && echo 'echo "  ╚══════════════════════════════╝"' >> /root/.bashrc \
    && echo 'echo ""' >> /root/.bashrc

# Create folders
RUN mkdir -p /root/main/arvin

WORKDIR /root/main/arvin

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/start.sh"]
