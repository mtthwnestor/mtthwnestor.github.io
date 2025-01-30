UNAME := $(shell uname)
PYTHON_IMAGE := python:3
NODE_IMAGE := node:22
PUPPETEER_IMAGE := ghcr.io/puppeteer/puppeteer:22.15.0
OLLAMA_IMAGE := ollama/ollama:latest
OPEN-WEBUI_IMAGE := ghcr.io/open-webui/open-webui:main

python-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name resume-python -w /app -v "$$PWD":/app $(PYTHON_IMAGE) /bin/bash

node-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name resume-node --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app -e XDG_CONFIG_HOME=/tmp/.chromium -e PUPPETEER_CACHE_DIR="/app/.cache/puppeteer" $(NODE_IMAGE) /bin/bash

html:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --rm -it --name mtthwnestor-resume --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app -e XDG_CONFIG_HOME=/tmp/.chromium -e PUPPETEER_CACHE_DIR="/app/.cache/puppeteer" $(NODE_IMAGE) /bin/bash -c "npm ci"
	@docker run --rm -it --name mtthwnestor-resume --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "npx resumed --theme jsonresume-theme-even --output index.html"
	@docker run --rm -it --name mtthwnestor-resume --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "npx resumed --theme @jsonresume/jsonresume-theme-class --output matthew-nestor.html"
	@docker run --rm -it --name mtthwnestor-resume --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "npx resumed resume-retail.json --theme jsonresume-theme-even --output index-retail.html"
	@docker run --rm -it --name mtthwnestor-resume --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "npx resumed resume-retail.json --theme @jsonresume/jsonresume-theme-class --output matthew-nestor-retail.html"

pdf:
	make html
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@if [ "$(UNAME)" != "Darwin" ]; then \
		docker run --rm -i --init --cap-add=SYS_ADMIN --user $$(id -u):$$(id -g) -w /app -v "$$PWD":/app -e XDG_CONFIG_HOME=/tmp/.chromium -e PUPPETEER_CACHE_DIR="/app/.cache/puppeteer" $(PUPPETEER_IMAGE) /bin/bash -c "npx puppeteer browsers install chrome && npm run pdf-export"; \
	fi

resume:
	make pdf
	cp photo.jpg public/
	mv index.html public/
	mv matthew-nestor.html public/
	mv index-retail.html public/
	mv matthew-nestor-retail.html public/
	find . -maxdepth 1 -name "Sample*.pdf" -exec cp '{}' public/ \;
	@if [ "$(UNAME)" != "Darwin" ]; then \
		mv resume.pdf public/; \
		mv matthew-nestor.pdf public/; \
		mv resume-retail.pdf public/; \
		mv matthew-nestor-retail.pdf public/; \
	fi

ollama:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --gpus=all -d --init -v ollama:/root/.ollama -p 11434:11434 --name ollama $(OLLAMA_IMAGE)
	@docker run -d --init -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data -v ./public:/app/backend/data/docs -e WEBUI_AUTH=false --name open-webui --restart always $(OPEN-WEBUI_IMAGE)

clean-python:
	if test -d "$$PWD/__pycache__"; then rm -rf "$$PWD/__pycache__"; fi

clean-node:
	if test -d "$$PWD/node_modules"; then rm -rf "$$PWD/node_modules"; fi

clean:
	make clean-python
	make clean-node
	if test -d ".cache/*"; then find $$PWD/.cache/* -maxdepth 0 -type d -exec rm -rf '{}' \;; fi
	rm -f "$$PWD/index.html" "$$PWD/public/index.html" "$$PWD/resume.pdf" "$$PWD/public/resume.pdf" "$$PWD/matthew-nestor.html" "$$PWD/public/matthew-nestor.html" "$$PWD/matthew-nestor.pdf" "$$PWD/public/matthew-nestor.pdf" "$$PWD/index-retail.html" "$$PWD/public/index-retail.html" "$$PWD/resume-retail.pdf" "$$PWD/public/resume-retail.pdf" "$$PWD/matthew-nestor-retail.html" "$$PWD/public/matthew-nestor-retail.html" "$$PWD/matthew-nestor-retail.pdf" "$$PWD/public/matthew-nestor-retail.pdf" "$$PWD/public/photo.jpg" "$$PWD"/qemu_*
	find public/ -name "Sample*.pdf" -exec rm -f '{}' \;
