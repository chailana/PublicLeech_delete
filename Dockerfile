# Use the base Docker image for Python
FROM python:3.9.5-slim-buster

WORKDIR /app

# Disable pip caching to reduce image size
ENV PIP_NO_CACHE_DIR 1
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Asia/Kolkata

# Update and install required packages
RUN apt -qq update && apt -qq install -y --no-install-recommends \
    curl \
    git \
    gnupg2 \
    unzip \
    wget \
    build-essential gcc \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free

# Add keys for additional repositories
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -

RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list'

# Update and install more packages
RUN apt -qq update && apt -qq install -y --no-install-recommends \
    apt-transport-https \
    coreutils aria2 jq pv \
    ffmpeg \
    mkvtoolnix \
    p7zip rar unrar zip \
    megatools mediainfo rclone && \
    apt purge -y software-properties-common && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp

# Copy all project files into the container
COPY . .

# Install Python dependencies
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Give execute permissions to the start.sh script
RUN chmod +x start.sh

# Run the start.sh script when the container starts
CMD ["./start.sh"]
