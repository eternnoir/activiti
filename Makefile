all: build

build:
	@docker build --rm=false --tag=${USER}/activiti .

test:
	build
	@docker run --name='activiti' \
	-it \
	--rm \
	-p 8080:8080 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $$(which docker):/bin/docker \
	${USER}/activiti

run:
	@docker run --name='activiti' \
        -d \
	-p 8080:8080 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $$(which docker):/bin/docker \
	${USER}/activiti

prod:
	@docker run --name='activiti' \
        -d \
	-p 8080:8080 \
        --link activiti-mysql:mysql \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $$(which docker):/bin/docker \
	${USER}/activiti

logs:
	@docker logs -f activiti
