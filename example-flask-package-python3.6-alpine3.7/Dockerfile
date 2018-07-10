FROM chuckamus-prime/uwsgi-nginx-flask:python3.6-alpine3.7

COPY ./app /app

#copy certs into container
COPY ./certs/chain /etc/pki/nginx/
COPY ./certs/private /etc/pki/nginx/private/