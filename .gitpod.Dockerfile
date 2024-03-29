FROM gitpod/workspace-base:latest
SHELL ["/bin/bash", "-c"]
USER gitpod
ARG version="0.22.1"
RUN wget "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -O ~/awscliv2.zip \
    && cd ~ && unzip ~/awscliv2.zip && rm ~/awscliv2.zip \
    && sudo ~/aws/install \
    && mkdir -p ~/.aws \
    && echo "[default]" >> ~/.aws/config && echo "region=ap-northeast-1" >> ~/.aws/config && echo "output=json" >>  ~/.aws/config && echo "cli_pager=" >> ~/.aws/config \
    && touch ~/.terraformrc \
    && echo "plugin_cache_dir = \"$HOME/.terraform.d/plugin-cache\"" >> ~/.terraformrc && echo "disable_checkpoint = true" >> ~/.terraformrc \
    && mkdir -p ~/.terraform.d/plugin-cache \
    && git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && sudo ln -s ~/.tfenv/bin/* /usr/local/bin/ \
    && tfenv --version \
    && tfenv install latest \
    && tfenv use latest \
    && tfenv list \
    && terraform --version \
    && wget https://releases.hashicorp.com/sentinel/${version}/sentinel_${version}_linux_amd64.zip -O ~/sentinel.zip \
    && cd ~ && sudo unzip ~/sentinel.zip -d /usr/local/bin/ && rm ~/sentinel.zip \
    && sentinel --version

