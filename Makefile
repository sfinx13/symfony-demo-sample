.DEFAULT_GOAL := help
.PHONY: help

DOCKER_COMP    = docker compose
SERVICE_PHPFPM = myapp_phpfpm
SERVICE_MYSQL  = myapp_myqsl
DATABASE_USER  = myapp
DATABASE_NAME  = myapp_db
PATH_DUMP_SQL  = data/dump.sql
PHPUNIT        = ./vendor/bin/phpunit
SYMFONY        = php bin/console
YARN            = yarn
NPX            = npx

help:
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

build: ## Install local environement
	@bash -l -c 'make .check .env .destroy .setup run .sleep composer create-db yarn-install yarn-build'

run: ## Start containers
	@echo -e '\e[1;32mStart containers\032'
	@bash -l -c '$(DOCKER_COMP) up -d'
	@echo -e '\e[1;32mContainers running\032'

down: ## Shutdown containers
	@echo -e '\e[1;32mStop containers\032'
	@bash -l -c '$(DOCKER_COMP) down'
	@echo -e '\e[1;32mContainers stopped\032'

sh: ## Log to phpfpm container
	@echo -e '\e[1;32mLog to phpfpm container\032'
	@bash -l -c '$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} sh'

mysql: ## Log to mysql container
	@echo -e '\e[1;32mLog to mysql container\032[0m'
	@bash -l -c '$(DOCKER_COMP) exec -it ${SERVICE_MYSQL} mysql -u myapp -pmyapp myapp_db'

logs: ## Show container logs
	@$(DOCKER_COMP) logs --follow

console: ## Execute application command
	@echo $(SYMFONY) app:$(app)
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} $(SYMFONY) app:$(app)

composer: ## Install composer dependencies
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} composer install --dev --no-interaction --optimize-autoloader
	@echo "\033[33mInstall tools dependencies ...\033[0m"
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} composer install --working-dir=tools/php-cs-fixer --dev --no-interaction --optimize-autoloader

clear-cache: ## Clear cache prod: make-clear-cache env=[dev|prod|test]
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} $(SYMFONY) c:c --env=$(env)

cc: clear-cache

create-db: ## Create database
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:database:drop --force --no-interaction || true"
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:database:create --no-interaction"
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:migrations:migrate --no-interaction"
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:fixtures:load --no-interaction"

drop-db: ## Drop database
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:database:drop --force --no-interaction"

load-data: ## Load database from dump
	@$(DOCKER_COMP) exec -T ${SERVICE_MYSQL} mysql -u $(DATABASE_USER) -pmyapp $(DATABASE_NAME) < $(PATH_DUMP_SQL)

migration: ## Build migrations
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev make:migration --no-interaction"

load-migrations: ## Play migrations
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:migrations:migrate --no-interaction"

load-fixtures: ## Load database from fixtures
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=dev doctrine:fixtures:load --no-interaction"

create-db-test: ## Create test database
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=test doctrine:database:drop --force --no-interaction || true"
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=test doctrine:database:create --no-interaction"
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=test doctrine:migrations:migrate --no-interaction"
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(SYMFONY) --env=test doctrine:fixtures:load --no-interaction"


test: ## Run all tests
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "$(PHPUNIT) --stop-on-failure --testdox -d memory_limit=-1"

test-coverage: ## Generate phpunit coverage report in html
	@$(DOCKER_COMP) exec ${SERVICE_PHPFPM} sh -c "XDEBUG_MODE=coverage $(PHPUNIT) --coverage-html coverage"

e2e: ## Run E2E tests
	@$(NPX) cypress open


stan: ## Run PHPStan
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} composer stan

cs-check: ## Check source code with PHP-CS-Fixer
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} composer cs-check

cs-fix: ## Fix source code with PHP-CS-Fixer
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} composer cs-fix

yarn-install: ## Install the dependencies in the local node_modules folder
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} $(YARN) install

yarn-build: ## Install the dependencies in the local node_modules folder
	@$(DOCKER_COMP) exec -it ${SERVICE_PHPFPM} $(YARN) run build

.env:
	@bash -l -c 'cp .env.dist .env'

.check:
	@echo "\033[31mWARNING!!!\033[0m Executing this script will reinitialize the project and all of its data"
	@( read -p "Are you sure you wish to continue? [y/N]: " sure && case "$$sure" in [yY]) true;; *) false;; esac )

.destroy:
	@echo "\033[33mRemoving containers ...\033[0m"
	@$(DOCKER_COMP) rm -v --force --stop || true
	@echo "\033[32mContainers removed!\033[0m"

.setup:
	@echo "\033[33mBuilding containers ...\033[0m"
	@$(DOCKER_COMP) build
	@echo "\033[32mContainers built!\033[0m"

.sleep:
	@sleep 15