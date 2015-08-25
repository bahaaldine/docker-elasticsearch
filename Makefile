NAME = bahaaldine/docker-elasticsearch
VERSION = 1.6.0

.PHONY: all build test tag_latest release ssh

all: build tag_latest

build:
	docker build -t $(NAME):$(VERSION) --rm .

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest