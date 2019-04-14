FROM python:3.7-alpine
MAINTAINER Minas Pantelidakis
# Goal : keep docker image to absolute minimum size

# It does not allow python to buffer outputs
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt

# use apk to add postgres client to the python image
RUN apk add --update --no-cache postgresql-client

# --virtual gives an alias to the dependencies so we can easily
# remove them after requirements have been installed
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev

RUN pip install -r /requirements.txt

# delete temporary dependencies
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app


# Create a user that will only run applications
RUN adduser -D user

# Switch to that user
USER user

# If we don't execute the above lines of code, the image will run the app using root account.
# If someone compromises our app, gg qq .