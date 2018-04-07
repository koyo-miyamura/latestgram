FROM ruby:2.5.1

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

EXPOSE 4567
#CMD ["bundle", "exec", "ruby", "myapp.rb", "-o", "0.0.0.0"]