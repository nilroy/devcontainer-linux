FROM python:3.9.13-slim-bullseye AS runtime
ARG USER_NAME
ARG USER_ID

LABEL author="Nilanjan Roy"
LABEL email="nilanjan1.roy@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV HOME_DIR /home/${USER_NAME}

COPY . ${HOME_DIR}

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y  sshpass gettext-base jq sudo python-is-python3 curl \
    && mkdir -m 755 -p ${HOME_DIR} \
    && useradd -u ${USER_ID} -s /bin/bash -d ${HOME_DIR} -m ${USER_NAME}  \
    && chown -R ${USER_NAME} ${HOME_DIR} 

ENV PATH ${HOME_DIR}/.local/bin:${PATH} 

USER ${USER_NAME}
WORKDIR ${HOME_DIR}

RUN pip3 install --upgrade pip \
    && pip3 install ansible \
    && ansible-galaxy collection install community.general 

WORKDIR ${HOME_DIR}

CMD ["/bin/bash"]
    
