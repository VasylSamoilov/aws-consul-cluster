FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y ansible-lint shellcheck

ADD ansible /ansible
ADD terraform /terraform
