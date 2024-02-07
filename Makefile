all: VCS_REF = $(shell git rev-parse --short HEAD)
all:
	@docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=$(VCS_REF) \
		-t gremid/cuda-clojure-python:$(VCS_REF) .
