FROM ruby:2.5.1

WORKDIR /app

CMD ["bundle", "update"]
CMD ["bundle", "install"]

EXPOSE 4567
CMD ["bundle", "exec", "ruby", "myapp.rb"]