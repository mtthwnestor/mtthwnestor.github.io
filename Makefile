UNAME := $(shell uname)
NODE_IMAGE_TAG := 20.11.1

node-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --rm -it --name mtthwnestor-node -v "$$PWD":/app node:$(NODE_IMAGE_TAG) /bin/bash

resume:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app node:$(NODE_IMAGE_TAG) /bin/bash -c "cd /app && npm install"
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app node:$(NODE_IMAGE_TAG) /bin/bash -c "cd /app && npx resumed --theme jsonresume-theme-even --output public/index.html"