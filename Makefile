.DEFAULT_GOAL := help
.PHONY: help
help: ## helpを表示
	@echo '  see:'
	@echo '   - https://github.com/yyh-gl/tech-blog'
	@echo ''
	@grep -E '^[%/a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}'

.PHONY: new
new: ## 記事テンプレート生成
	@if [ -z "${title}" ]; then \
		echo 'titleを指定してください。'; \
		exit 1; \
	fi
	git checkout master
	git checkout -b ${title}
	@echo ''
	hugo new blog/${title}.md
	@echo ''
	mkdir -p ./static/img/tech-blog/`date +"%Y/%m"`/${title}
	@echo ''
	open ./static/img/tech-blog/`date +"%Y/%m"`/${title}
	@echo ''
	open http://localhost:1313/tech-blog/

.PHONY: post
post: ## 記事を投稿
	@if [ -z "${title}" ]; then \
		echo 'titleを指定してください。'; \
		exit 1; \
	fi
	curl -X POST https://super.hobigon.work/api/v1/blogs -H "Content-Type: application/json" -d "{\"title\":\"${title}\"}"
	@echo ''
	git merge ${title}
	git push origin master

.PHONY: create-ogp
create-ogp: ## OGP画像を生成
	@if [ -z "${title}" ]; then \
		echo 'titleを指定してください。'; \
		exit 1; \
	fi
	tcardgen -c template.yaml -f static/font/kinto-master/Kinto\ Sans -o static/img/tech-blog/`date +"%Y/%m"`/${title} content/blog/${title}.md
	mv static/img/tech-blog/`date +"%Y/%m"`/${title}/${title}.png static/img/tech-blog/`date +"%Y/%m"`/${title}/featured.png
