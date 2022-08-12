FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1
RUN bundle config

COPY . /peml/jekyll_src

WORKDIR peml/jekyll_src 
#/usr/src/app

EXPOSE 4000

#COPY Gemfile Gemfile.lock ./
RUN bundle install

#COPY . .
CMD bundle exec jekyll serve --host=0.0.0.0  -V

#docker run -d -p 4000:4000 containr_name