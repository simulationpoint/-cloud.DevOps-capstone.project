
# Image with python to deploy the flask app

FROM python:3.7-alpine
WORKDIR /gmn

# Copy all the files in the repo
ADD . /gmn

# Installing requirements.txt
RUN pip install -r requirements.txt

# The aplication will be run in port 9090
EXPOSE 9090

# Command to run the app
CMD ["python","web.py"]


