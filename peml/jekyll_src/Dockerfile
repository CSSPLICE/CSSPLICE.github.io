FROM ruby:3.4.13

WORKDIR /peml/jekyll_src
ENV BUNDLE_FROZEN=true

COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "-V"]
