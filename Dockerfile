FROM dannyben/alpine-ruby:3.2.2

ENV MADNESS_VERSION=0.4.4

WORKDIR /app

VOLUME /app

RUN gem install bashly --version $MADNESS_VERSION && \
    gem update --system

EXPOSE 3000

CMD []

ENTRYPOINT ["loadrunner"]

