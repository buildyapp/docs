all:
	@mkdocs build

serve:
	@mkdocs serve

publish:
	@mkdocs gh-deploy
