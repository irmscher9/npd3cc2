# Use an official Python runtime as a parent image
FROM python:3.6-alpine

# Set the working directory to /app
WORKDIR /app

COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN python -m venv venv

RUN apk update && \
 apk add python3 postgresql-libs && \
 apk add --virtual .build-deps gcc python3-dev musl-dev postgresql-dev && \
 python3 -m pip install -r requirements.txt --no-cache-dir && \
 apk --purge del .build-deps

RUN pip install psycopg2

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV FLASK_APP app.py
ENV EMAIL_USER mywebsidekicks@gmail.com
ENV EMAIL_PASSWORD puff1st0lt0

#
RUN source venv/bin/activate
RUN flask db migrate
RUN flask db upgrade

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]