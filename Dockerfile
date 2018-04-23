FROM dannyben/alpine-ruby

WORKDIR /app

RUN gem install json loadrunner

EXPOSE 3000

CMD []

ENTRYPOINT ["loadrunner"]

