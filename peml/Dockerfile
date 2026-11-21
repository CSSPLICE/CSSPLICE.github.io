FROM ruby:3.4.13

WORKDIR /peml/jekyll_src
ENV BUNDLE_FROZEN=true

COPY jekyll_src/Gemfile jekyll_src/Gemfile.lock ./
RUN bundle install
COPY jekyll_src/ ./

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "-V"]
