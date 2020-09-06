FROM python:3.6-alpine

RUN adduser -D mybaros

WORKDIR /home/mybaros

RUN apk update
RUN apk add build-base libffi-dev openssl-dev bash busybox-extras

COPY requirements.txt requirements.txt
RUN python -m venv venv
RUN venv/bin/pip install --upgrade pip
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn pymysql

COPY app app
COPY migrations migrations
COPY mybaros.py config.py boot.sh .env ./
RUN chmod a+x boot.sh

ENV FLASK_APP mybaros.py

RUN chown -R mybaros:mybaros ./
USER mybaros

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]