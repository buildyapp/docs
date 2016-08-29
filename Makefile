all: build
	@mkdocs build

build:
	@mkdocs build

serve:
	@mkdocs serve

publish: build
	@mkdocs gh-deploy
