# Mongo Export Surgeon

[![Docker Image CI](https://github.com/tehKapa/mongoexportsurgeon/actions/workflows/docker-image.yml/badge.svg)](https://github.com/tehKapa/mongoexportsurgeon/actions/workflows/docker-image.yml)

An easy way to export documents associated with an ID from multiple collections. Surgically.

## Build

```
docker build -t tehkapa/mongoexportsurgeon .
```

## Run

```
docker run --name mongoas -it \
  -e DBNAME=database \
  -e USERNAME=user \
  -e PASSWORD=password \
  -e HOST=mongo-server \
  -e AWSACCESSKEYID=AKxxxxxx \
  -e AWSSECRETACCESSKEY=bHxxxxxxxx \
  -e BUCKET=my-bucket \
  tehkapa/mongoexportsurgeon
```

You can pass organizationID on run command with `-e ORG=xxxxxxxxxx`
