UNAME := $(shell uname)
NODE_IMAGE_TAG := 20.11.1

node-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --rm -it --name mtthwnestor-node -v "$$PWD":/app node:$(NODE_IMAGE_TAG) /bin/bash

html:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app node:$(NODE_IMAGE_TAG) /bin/bash -c "cd /app && npm install"
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app node:$(NODE_IMAGE_TAG) /bin/bash -c "cd /app && npx resumed --theme jsonresume-theme-even --output index.html"

pdf:
	make html
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@if [ "$(UNAME)" != "Darwin" ]; then \
		docker run --rm -i --init --cap-add=SYS_ADMIN --user 1000:1000 -v "$$PWD":/app ghcr.io/puppeteer/puppeteer:22.6.3 /bin/bash -c "cd /app && npx puppeteer browsers install chrome && npm run pdf-export"; \
	fi

resume:
	make pdf
	cp photo.jpg public/
	mv index.html resume.pdf public/

clean:
	rm -f "$$PWD/public/index.html" "$$PWD/public/photo.jpg" "$$PWD/public/resume.pdf" "$$PWD/index.html" "$$PWD/resume.pdf" "$$PWD"/qemu_*
	if test -d "$$PWD/node_modules"; then sudo rm -r "$$PWD/node_modules"; fi