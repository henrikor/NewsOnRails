FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y \
	build-essential \
	libpq-dev \
	mysql-client \
	imagemagick \
	ruby-rmagick \
	libmagickwand-dev \
	nodejs

RUN mkdir /myapp
WORKDIR /myapp
#ADD Gemfile /myapp/Gemfile
ADD . /myapp
RUN bundle config --global silence_root_warning 1 
RUN bundle install
