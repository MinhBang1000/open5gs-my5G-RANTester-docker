# FROM golang:1.14.4-stretch
FROM golang:1.14-buster

RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
 && sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
 && sed -i 's|buster-updates|buster|g' /etc/apt/sources.list \
 && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

WORKDIR /workspace

COPY my5G-RANTester my5G-RANTester/

RUN cd my5G-RANTester  \
    && go mod download 

# Move to the binary path
WORKDIR /workspace/my5G-RANTester/cmd

RUN go build -o app

# Install iperf
# RUN apt update && apt install -y iperf
RUN apt-get update && apt-get install -y iperf && rm -rf /var/lib/apt/lists/*


# Config files volume
VOLUME [ "/workspace/my5G-RANTester/config" ]
