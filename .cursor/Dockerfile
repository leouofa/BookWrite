# Use Ubuntu as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm-dev \
    libyaml-dev \
    libsqlite3-dev \
    sqlite3 \
    libpq-dev \
    postgresql-client \
    libmysqlclient-dev \
    mysql-client \
    redis-tools \
    imagemagick \
    libvips-dev \
    shared-mime-info \
    tzdata \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Install rbenv and Ruby
RUN git clone https://github.com/rbenv/rbenv.git /opt/rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /opt/rbenv/plugins/ruby-build && \
    /opt/rbenv/bin/rbenv install 3.2.0 && \
    /opt/rbenv/bin/rbenv global 3.2.0

# Add rbenv to PATH
ENV PATH="/opt/rbenv/bin:/opt/rbenv/shims:$PATH"

# Install Bundler and Rails
RUN /opt/rbenv/shims/gem install bundler rails

# Create ubuntu user and set up home directory
RUN useradd -m -s /bin/bash ubuntu && \
    usermod -aG sudo ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set user and working directory
USER ubuntu
WORKDIR /home/ubuntu

# Set up rbenv for ubuntu user
RUN echo 'export PATH="/opt/rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install common development tools
RUN /opt/rbenv/shims/gem install \
    solargraph \
    rubocop \
    brakeman \
    bundler-audit

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]

# Expose common Rails ports
EXPOSE 3000 3001
