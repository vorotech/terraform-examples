help:
	@awk 'BEGIN {FS = ":.*##"; printf "\n Usage: make <command>\n\033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install: ## install project requirements
	@echo "-->  Installing project requirements"
	./scripts/install.sh

fmt: ## runs terraform fmt
	@echo "-->  Terraform format"
	terraform fmt -recursive ./

ci: .fmt-ci ## runs CI checks

.fmt-ci: 
	@echo "-->  Terraform format"
	terraform fmt -check -diff -recursive ./
