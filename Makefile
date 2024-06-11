UNAME := $(shell uname)
RUBY_IMAGE := ruby:3.3.1-bookworm
PYTHON_IMAGE := python:3.12.1-bookworm
NODE_IMAGE := node:20.11.1
LYCHEE_IMAGE := lycheeverse/lychee:0.14.3
PUPETEER_IMAGE := ghcr.io/puppeteer/puppeteer:22.6.3

jekyll-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name resume-ruby -w /app -v "$$PWD":/app -p 80:4000 -p 35729:35729 -e BUNDLE_FORCE_RUBY_PLATFORM=true -e BUNDLE_PATH=.gems-cache $(RUBY_IMAGE)

python-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name resume-python -w /app -v "$$PWD":/app $(PYTHON_IMAGE) /bin/bash

node-env:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --init --rm -it --name resume-node -w /app -v "$$PWD":/app $(NODE_IMAGE) /bin/bash

html:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "cd /app && npm install"
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "cd /app && npx resumed --theme jsonresume-theme-even --output index.html"
	@docker run --rm -it --name mtthwnestor-resume -v "$$PWD":/app $(NODE_IMAGE) /bin/bash -c "cd /app && npx resumed --theme @jsonresume/jsonresume-theme-class --output matthew-nestor.html"

pdf:
	make html
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@if [ "$(UNAME)" != "Darwin" ]; then \
		docker run --rm -i --init --cap-add=SYS_ADMIN --user 1000:1000 -v "$$PWD":/app $(PUPETEER_IMAGE) /bin/bash -c "cd /app && npx puppeteer browsers install chrome && npm run pdf-export"; \
	fi

resume:
	make pdf
	cp photo.jpg public/
	mv index.html public/
	mv matthew-nestor.html public/
	find . -maxdepth 1 -name "Sample*.pdf" -exec cp '{}' public/ \;
	@if [ "$(UNAME)" != "Darwin" ]; then \
		mv resume.pdf public/; \
		mv matthew-nestor.pdf public/; \
	fi

ollama:
	@if [ "$(UNAME)" = "Darwin" ]; then \
		colima start; \
	fi
	@docker run --gpus=all -d --init -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:0.1.37
	@docker run -d --init -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data -v ./public:/app/backend/data/docs -e WEBUI_AUTH=false --name open-webui --restart always ghcr.io/open-webui/open-webui:git-90503be

clean-jekyll:
	if test -d "$$PWD/.gems-cache"; then rm -r "$$PWD/.gems-cache"; fi
	if test -d "$$PWD/.jekyll-cache"; then rm -r "$$PWD/.jekyll-cache"; fi
	if test -d "$$PWD/_site"; then rm -r "$$PWD/_site"; fi
	if test -e "$$PWD/.jekyll-metadata"; then rm -r "$$PWD/.jekyll-metadata"; fi
	if test -d "$$PWD/.sass-cache"; then rm -r "$$PWD/.sass-cache"; fi

clean-python:
	if test -d "$$PWD/__pycache__"; then rm -r "$$PWD/__pycache__"; fi

clean-node:
	if test -d "$$PWD/node_modules"; then rm -r "$$PWD/node_modules"; fi

clean-lychee:
	if test -e "$$PWD/.lycheecookies"; then rm -r "$$PWD/.lycheecookies"; fi
	if test -e "$$PWD/.lycheecache"; then rm -r "$$PWD/.lycheecache"; fi
	if test -e "$$PWD/scripts/reports/lychee.md"; then rm -r "$$PWD/scripts/reports/lychee.md"; fi

clean:
	make clean-jekyll
	make clean-python
	make clean-node
	make clean-lychee
	rm -f "$$PWD/public/index.html" "$$PWD/public/matthew-nestor.html" "$$PWD/public/photo.jpg" "$$PWD/public/resume.pdf" "$$PWD/public/matthew-nestor.pdf" "$$PWD/index.html" "$$PWD/matthew-nestor.html" "$$PWD/resume.pdf" "$$PWD/matthew-nestor.pdf" "$$PWD"/qemu_*