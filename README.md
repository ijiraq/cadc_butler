# CADC Butler Server

The CADC operates an LSST IDAC.  The CADC site provides a Butler server for
metadata search backed bu a PostgreSQL database.  Data files are stored
in the CADC Storage Inventory system.  The Butler server is configured to
provide back to the client the URL that points back to the CADC SI and the user
must then authenticate to the CADC SI to retrieve the data file.  Authentication
is managed by the Butler client and based on CADC access tokens.

## Overview

This document provides instructions for setting up the LSST Butler server. The 
Butler Server is a [uvicorn](https://www.uvicorn.org/) ASGI web server listening on port 8080.

## compose.yaml

The Docker Compose file (compose.yaml) defines the services required to run the Butler server.

To start the LSST Butler Server: in root directory run: `docker compose up`

## butler.env

The butler.env file contains environment variables that configure the 
uvicorn web server and the Butler app running on the server.

### UVICORN configuration
The following environment variables configure the uvicorn web server:
#### UVICORN_HOST="0.0.0.0"
The host address that the uvicorn server will bind to on startup.
#### UVICORN_PORT="8080"
The port that the uvicorn server will bind to on startup.
#### UVICORN_LOG_LEVEL="info"
The log level for the uvicorn server.

#### DAF_BUTLER_SERVER_REPOSITORIES

String that provies a list of Butler repositories that the server will serve. This variable provides the path
to find the dc2.yaml and dp1.yaml files.

#### DAF_BUTLER_SERVER_GAFAELFAWR_URL

is set to DISABLED to disable this feature of the Butler server, which is the LSST Gafaelfawr authentication service.

#### DAF_BUTLER_SERVER_AUTHENTICATION 

is set to cadc to ensure that the Butler
server does not pass back presigned URLs to clients.

#### PGPASSWORD 

* At launch time, set the password for the lsstuser account as the PGPASSWORD environment variable or use another method.

## dc2.yaml

The dc2.yaml file contains the configuration for the Butler database for the DC2 release

## dp1.yaml

The dp1.yaml file contains the configuration for the Butler database for the DP1 release

# Setting up the Butler Client

The Butler Client is configured by setting the Butler to:  
https://your.server.domain/api/butler/repo/dp1/butler.yaml


## INGESTING CONTENT

The content of the butler is loaded from a tar file that should be distributed via rucio
To add this content to the data butler database use the ingest.sh script in butler_ingest

https://rubinobs.atlassian.net/wiki/external/ZmI4OGZmY2ZiY2I5NDBlOTk4YzJhNzJjODFjNjg1MTM
for details on setting up a butler remote server this script should
be run on the lsst:sciplat-lab container from a location that can make
direct connection to the postgres database

Put the list of containers that we populating into our butler in the file

butler_ingest/container_list.txt

Place the TAR file for the data release into a place you like and define
PATH_TO_BUTLER_DUMP=${PATH_TO_BUTLER_DUMP:-${DIRNAME}/dp1-dump-DM-51372.tar}
to point at that file in compose.yaml or elsewhere and then

docker compose run ingest


