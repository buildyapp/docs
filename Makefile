all:
	@daux generate --source=. --destination=static

publish:
	@make all
	@git checkout gh-pages
	@ls | grep -v static | xargs rm -rf
	@mv static/* .
	@git add --all
	@git commit -m "Prepare to publish" || true
	@git push
	@git checkout master
