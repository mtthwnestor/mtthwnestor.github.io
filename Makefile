UNAME := $(shell uname)
DOCKER_RUN := docker run --rm --init -i -t --env-file '.env' --user $(shell id -u):$(shell id -g) -w /app -v "$$PWD":/app
PYTHON_IMAGE := python:3
NODE_IMAGE := node:22
PANDOC_IMAGE := pandoc/latex:latest
PUPPETEER_IMAGE := ghcr.io/puppeteer/puppeteer:22.15.0
OLLAMA_IMAGE := ollama/ollama:latest
OPEN-WEBUI_IMAGE := ghcr.io/open-webui/open-webui:main

python-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@$(DOCKER_RUN) --name resume-python $(PYTHON_IMAGE) /bin/bash

node-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@$(DOCKER_RUN) --name resume-node $(NODE_IMAGE) /bin/bash

html:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@$(DOCKER_RUN) --name mtthwnestor-resume $(NODE_IMAGE) /bin/bash -c "npm ci"
	@$(DOCKER_RUN) --name mtthwnestor-resume $(NODE_IMAGE) /bin/bash -c "npm run html-export"

pdf:
	make html
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@if [ "$(UNAME)" != "Darwin" ]; then \
		$(DOCKER_RUN) --cap-add=SYS_ADMIN $(PUPPETEER_IMAGE) /bin/bash -c "npx puppeteer browsers install chrome && npm run pdf-export"; \
	fi

docx:
	make html
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@$(DOCKER_RUN) $(PANDOC_IMAGE) resume0.html -o resume0.docx
	@$(DOCKER_RUN) $(PANDOC_IMAGE) resume1.html -o resume1.docx
	@$(DOCKER_RUN) $(PANDOC_IMAGE) resume-retail0.html -o resume-retail0.docx
	@$(DOCKER_RUN) $(PANDOC_IMAGE) resume-retail1.html -o resume-retail1.docx

resume:
	make html
	make pdf
	make docx
	cp photo.jpg public/
	find . -maxdepth 1 -name "resume*.html" -exec mv '{}' public/ \;
	cp public/resume0.html public/index.html
	find . -maxdepth 1 -name "resume*.docx" -exec mv '{}' public/ \;
	find . -maxdepth 1 -name "Sample*.pdf" -exec cp '{}' public/ \;
	@if [ "$(UNAME)" != "Darwin" ]; then \
		find . -maxdepth 1 -name "resume*.pdf" -exec mv '{}' public/ \;; \
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
	if test -d .cache/*; then find $$PWD/.cache/* -maxdepth 0 -type d -exec rm -rf '{}' \;; fi
	find . -name "resume*.html" -exec rm -f '{}' \;
	find . -name "resume*.pdf" -exec rm -f '{}' \;
	find . -name "resume*.docx" -exec rm -f '{}' \;
	find public/ -name "resume*.html" -exec rm -f '{}' \;
	find public/ -name "resume*.pdf" -exec rm -f '{}' \;
	find public/ -name "resume*.docx" -exec rm -f '{}' \;
	rm -f "$$PWD/public/index.html" "$$PWD/public/photo.jpg" "$$PWD"/qemu_*
	find public/ -name "Sample*.pdf" -exec rm -f '{}' \;
