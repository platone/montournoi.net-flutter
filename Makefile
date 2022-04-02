FLUTTER=/Users/archimede/Workspace/workspace-flutter/flutter/bin/flutter

##
## Help
##---------------------------------------------------------------------------

.DEFAULT_GOAL := help

.PHONY: help

help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

command-list: ## List console command list
	$(CONSOLE) list

##
## Internal rules
##---------------------------------------------------------------------------

.PHONY: build

get: ## Get Application
	$(FLUTTER) pub get

i18n: ## Get i18n
	$(FLUTTER) gen-l10n

doctor: ## Get Doctor
	$(FLUTTER) doctor -v

uc: ## Get iOS
	$(FLUTTER) upgrade
	$(FLUTTER) clean
    # pod install

ios: ## Get Doctor
	$(FLUTTER) build ios --release

icons: ## Get Doctor
	$(FLUTTER) pub run flutter_launcher_icons:main

build: ## Build Application
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs
