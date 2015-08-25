Elasticsearch.
================================

[![](https://badge.imagelayers.io/bahaaldine/docker-elasticsearch:latest.svg)](https://imagelayers.io/?images=bahaaldine/docker-elasticsearch:latest 'Get your own badge on imagelayers.io')

# Image description

Elasticsearch docker image that contains Marvel, Shield & Watcher

# Running as a standalone container

```bash
docker run -ti -p 9300:9300 -p 9200:9200  --add-host elasticsearch:192.168.59.103 bahaaldine/docker-elasticsearch
```

- 9200 : HTTP listening port
- 9300 : node to node communication, so that container can join the same Elasticsearch cluster
- add-host : adding an hostname mapping to boot2docker ip address (docker machine) so that the Elasticsearch node
will publish itself on this host. See the ```network.publish_host``` setting in the DockerFile.

# Running as part of a Docker Compose application

```lang
elasticsearch1:
  image: bahaaldine/docker-elasticsearch
  ports:
    - "9200:9200"
  volumes:
    - "logs/elasticsearch1:/var/log/elasticsearch"
    - "conf/elasticsearch:/etc/elasticsearch"
    - "data:/data"
  extra_hosts:
    - "elasticsearch:192.168.59.103"
```

The volumes section lets you map host directory to container directories, here, 
	- the logs: follow ES log activity without having to connect to the container
	- configurations: externalizing configuration lets you shape your node depending on your needs
	- node data: when shutting your container, node data are not lost !

## Building the Docker image

You can use the shipped `Makefile` to build the image,
exemple:

```bash
make all
````
Available arguments:
- build: build the docker image
- tag_latest: tag version to latest version
- all: apply build and tag_latest