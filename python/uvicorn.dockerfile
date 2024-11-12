FROM python:3.8-slim AS base

WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt
COPY . /app

EXPOSE 3000
ENTRYPOINT [ "uvicorn" ]
CMD [ "--host", \
  "0.0.0.0", \
  "--port", \
  "3000", \
  "asgi:app" ]
