REGISTRY = <your docker repo>
REGISTRY_PATH = <your repo name>
IMAGE_NAME = ssllabs
IMAGE_VERSION ?= latest
IMAGE_PATH = ${REGISTRY}/${REGISTRY_PATH}/${IMAGE_NAME}:${IMAGE_VERSION}

build-app:
	git clone https://github.com/ssllabs/ssllabs-scan.git build_dir
	cd build_dir && git checkout ${SSLLABS_VERSION}
	cd build_dir && CGO_ENABLED=0 go build --ldflags '-extldflags "-static"' ssllabs-scan.go && cp ssllabs-scan ..

build-docker:
	$(eval IMAGE_NAME=io-ssllabs-scan-bash)
	docker build -f Dockerfile.bash -t ${IMAGE_PATH} .
	$(eval IMAGE_NAME=io-ssllabs-scan-nginx)
	docker build -f Dockerfile.nginx -t ${IMAGE_PATH} .

push:
	$(eval IMAGE_NAME=io-ssllabs-scan-bash)
	docker push ${IMAGE_PATH}
	$(eval IMAGE_NAME=io-ssllabs-scan-nginx)
	docker push ${IMAGE_PATH}

clean:
	rm ssllabs-scan
	$(eval IMAGE_NAME=io-ssllabs-scan-bash)
	docker rmi -f ${IMAGE_PATH}
	$(eval IMAGE_NAME=io-ssllabs-scan-nginx)
	docker rmi -f ${IMAGE_PATH}


start: stop
	docker run -d --name $(IMAGE_NAME) \
		${IMAGE_PATH}

stop:
	@-docker rm -f $(IMAGE_NAME)

logs:
	docker logs -f $(IMAGE_NAME)

enter:
	docker exec -it $(IMAGE_NAME) sh
