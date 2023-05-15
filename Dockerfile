# see task: PipAuthenticate@1 in azure-pipelines.yml
# ARG PIP_EXTRA_URL
# COPY is Same as 'ADD', but without the tar and remote URL handling.
# RUN pip3 install -r /requirements.txt --extra-index-url $PIP_EXTRA_URL

# ARG is only available during the build of a Docker image (RUN etc)
# ENV values are available to containers
# RUN is an image build step, the state of the container after a RUN command will be committed to the container image.
# CMD is the command the container executes by default when you launch the built image.
# ENTRYPOINT is also closely related to CMD and can modify the way a container is started from an image.

# ARG INFA_EDC_AUTH
# ENV INFA_EDC_AUTH=$INFA_EDC_AUTH
# demo

FROM python:3.8-slim as release

WORKDIR /app

EXPOSE 80

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT [ "python", "app.py" ]
