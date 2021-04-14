FROM python:3.9.2-slim-buster as python-3.9-buster

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential git-core \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /root/

RUN pip install --upgrade pip
RUN pip install -r /root/requirements.txt --no-cache-dir
RUN python -m spacy download en_core_web_sm

FROM maven:3-openjdk-11
COPY --from=python-3.9-buster / /

RUN mvn dependency:copy-dependencies -DoutputDirectory=./jars -f /usr/local/lib/python3.9/site-packages/sutime/pom.xml


EXPOSE 3000
