FROM ruby:2.5.1

WORKDIR /app

CMD ["bundle", "install"]

EXPOSE 4567
CMD ["ruby", "myapp.rb"]

RUN ls