# NEO private network - Dockerfile
FROM microsoft/dotnet:2.1.4-runtime-bionic

LABEL maintainer="City of Zion"
LABEL authors="metachris, ashant, hal0x2328, phetter"

ENV DEBIAN_FRONTEND noninteractive

# Disable dotnet usage information collection
# https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry#behavior
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Install system dependencies. always should be done in one line
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    unzip \
    screen \
    expect \
    libleveldb-dev \
    git-core \
    wget \
    curl \
    git-core \
    python3.7 \
    python3.7-dev \
    python3.7-venv \
    python3-pip \
    libleveldb-dev \
    libssl-dev \
    vim \
    man \
    libunwind8

# APT cleanup to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# neo-python setup: clonse and install dependencies
RUN echo "alias python3=python3.7" >> /root/.bashrc
RUN git clone https://github.com/CityOfZion/neo-python.git --branch v0.8.2 /neo-python
WORKDIR /neo-python

# RUN git checkout development
RUN python3.7 -m pip install -e .
RUN wget https://s3.amazonaws.com/neo-experiments/neo-privnet.wallet

# Add the neo-cli package
ADD ./neo-cli.zip /opt/neo-cli.zip
ADD ./SimplePolicy.zip /opt/SimplePolicy.zip
ADD ./ApplicationLogs.zip /opt/ApplicationLogs.zip
ADD ./RpcSystemAssetTracker.zip /opt/RpcSystemAssetTracker.zip

# Extract and prepare four consensus nodes
RUN unzip -q -d /opt/node /opt/neo-cli.zip

# Extract and prepare SimplePolicy plugin
RUN unzip -q -d /opt/node/neo-cli /opt/SimplePolicy.zip

# Extract and prepare SimplePolicy plugin
RUN unzip -q -d /opt/node/neo-cli /opt/ApplicationLogs.zip

# Extract and prepare RpcSystemAssetTracker plugin
RUN unzip -q -d /opt/node/neo-cli /opt/RpcSystemAssetTracker.zip

# Remove zip neo-cli package
RUN rm /opt/neo-cli.zip
RUN rm /opt/SimplePolicy.zip
RUN rm /opt/ApplicationLogs.zip
RUN rm /opt/RpcSystemAssetTracker.zip

# Create chain data directories
RUN mkdir -p /opt/chaindata/node

# Add config files
ADD ./configs/config.json /opt/node/neo-cli/config.json
ADD ./configs/config.json /opt/node/neo-cli/config.orig.json
ADD ./configs/protocol.json /opt/node/neo-cli/protocol.json
ADD ./wallets/wallet.json /opt/node/neo-cli/
ADD ./configs/config-applicationlogs.json /opt/node/neo-cli/Plugins/ApplicationLogs/config.json
ADD ./configs/config-applicationlogs.json /opt/node/neo-cli/Plugins/ApplicationLogs/config.orig.json

# Add scripts
ADD ./scripts/run.sh /opt/
ADD ./scripts/run_datadir_wrapper.sh /opt/
ADD ./scripts/start_consensus_node.sh /opt/
ADD ./scripts/claim_neo_and_gas_fixedwallet.py /neo-python/
ADD ./scripts/claim_gas_fixedwallet.py /neo-python/
ADD ./wallets/neo-privnet.python-wallet /tmp/wallet

# Some .bashrc helpers: 'neopy', and a welcome message for bash users
RUN echo "alias neopy=\"cd /neo-python && np-prompt -p\"" >> /root/.bashrc
RUN echo "printf \"\n* Consensus nodes are running in screen sessions, check 'screen -ls'\"" >> /root/.bashrc
RUN echo "printf \"\n* neo-python is installed in /neo-python, with a neo-privnet.wallet file in place\"" >> /root/.bashrc
RUN echo "printf \"\n* You can use the alias 'neopy' in the shell to start neo-python's prompt.py with privnet settings\"" >> /root/.bashrc
RUN echo "printf \"\n* Please report issues to https://github.com/CityOfZion/neo-privatenet-docker\n\n\"" >> /root/.bashrc

# Inform Docker what ports to expose
EXPOSE 20332

EXPOSE 30332

# On docker run, start the consensus nodes
CMD ["/bin/bash", "/opt/run_datadir_wrapper.sh"]
