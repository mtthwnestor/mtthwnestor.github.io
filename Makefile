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
	@$(DOCKER_RUN) --name mtthwnestor-resume $(NODE_IMAGE) /bin/bash -c "npx resumed --theme jsonresume-theme-even --output index.html"
	@$(DOCKER_RUN) --name mtthwnestor-resume $(NODE_IMAGE) /bin/bash -c "npx resumed --theme @jsonresume/jsonresume-theme-class --output matthew-nestor.html"
	@$(DOCKER_RUN) --name mtthwnestor-resume $(NODE_IMAGE) /bin/bash -c "npx resumed resume-retail.json --theme jsonresume-theme-even --output index-retail.html"
	@$(DOCKER_RUN) --name mtthwnestor-resume $(NODE_IMAGE) /bin/bash -c "npx resumed resume-retail.json --theme @jsonresume/jsonresume-theme-class --output matthew-nestor-retail.html"

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
	@$(DOCKER_RUN) $(PANDOC_IMAGE) index.html -o resume.docx
	@$(DOCKER_RUN) $(PANDOC_IMAGE) matthew-nestor.html -o matthew-nestor.docx
	@$(DOCKER_RUN) $(PANDOC_IMAGE) index-retail.html -o resume-retail.docx
	@$(DOCKER_RUN) $(PANDOC_IMAGE) matthew-nestor-retail.html -o matthew-nestor-retail.docx

resume:
	make html
	make pdf
	make docx
	cp photo.jpg public/
	mv index.html public/
	mv resume.docx public/
	mv matthew-nestor.html public/
	mv matthew-nestor.docx public/
	mv index-retail.html public/
	mv resume-retail.docx public/
	mv matthew-nestor-retail.html public/
	mv matthew-nestor-retail.docx public/
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
	if test -d .cache/*; then find $$PWD/.cache/* -maxdepth 0 -type d -exec rm -rf '{}' \;; fi
	rm -f "$$PWD/index.html" "$$PWD/public/index.html" "$$PWD/resume.pdf" "$$PWD/public/resume.pdf" "$$PWD/resume.docx" "$$PWD/public/resume.docx" "$$PWD/matthew-nestor.html" "$$PWD/public/matthew-nestor.html" "$$PWD/matthew-nestor.pdf" "$$PWD/public/matthew-nestor.pdf" "$$PWD/matthew-nestor.docx" "$$PWD/public/matthew-nestor.docx" "$$PWD/index-retail.html" "$$PWD/public/index-retail.html" "$$PWD/resume-retail.pdf" "$$PWD/public/resume-retail.pdf" "$$PWD/resume-retail.docx" "$$PWD/public/resume-retail.docx" "$$PWD/matthew-nestor-retail.html" "$$PWD/public/matthew-nestor-retail.html" "$$PWD/matthew-nestor-retail.pdf" "$$PWD/public/matthew-nestor-retail.pdf" "$$PWD/matthew-nestor-retail.docx" "$$PWD/public/matthew-nestor-retail.docx" "$$PWD/public/photo.jpg" "$$PWD"/qemu_*
	find public/ -name "Sample*.pdf" -exec rm -f '{}' \;
