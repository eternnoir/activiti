all: build
build:
	@docker build --tag=${USER}/activiti .
test-run:
	@docker run --name='activiti' \
	-it \
	--rm \
	-p 8080:8080 \
	${USER}/activiti
