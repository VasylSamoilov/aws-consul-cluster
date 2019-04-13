.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

lint: build-lint ## runs linters
	docker run -it --rm linters find ./terraform -name "*.sh" -exec shellcheck {} \;
	docker run -it --rm linters find ./ansible -name "*.yml" -exec ansible-lint {} \;

build-lint: ## builds dockerfile with lint dependencies
	docker build -t linters .

configure-remote-state: ## configures remote state, requires $AWS_REGION, $BUCKET_NAME and optionally $DYNAMODB_TABLE variables to be set
	bash ./scripts/configure-remote-state.sh
