
CS_FIXER = vendor/bin/php-cs-fixer fix --config=.php_cs -v --using-cache=no --diff --diff-format=udiff --ansi
PHPUNIT = phpdbg -qrr vendor/bin/phpunit
PSALM = vendor/bin/psalm --threads=1 --no-cache --find-dead-code=always
SCRUTINIZER = vendor/bin/ocular code-coverage:upload

PHP_FILES_DIFF = $(shell git diff --name-only --diff-filter=ACMRTUXB $(1) | grep -iE \.php$)
CS_FIXER_TEST = if test "$(1)" ; then $(CS_FIXER) --dry-run $(1) ; else echo "Nothing to fix" ; fi
CS_FIXER_FIX = if test "$(1)" ; then $(CS_FIXER) $(1) ; else echo "Nothing to fix" ; fi

LOGS_DIR = logs
CLOVER_FILE = $(LOGS_DIR)/clover.xml
COVERAGE_REPORT_DIR = $(LOGS_DIR)/report
PSALM_REPORT_FILE = $(LOGS_DIR)/psalm.local.json

.PHONY: all
all: clean install test lint

.PHONY: lint
lint: psalm cs-test

.PHONY: clean
clean:
	rm -dfR $(LOGS_DIR)

.PHONY: build
build:
	mkdir -p $(LOGS_DIR)

.PHONY: install
install:
	composer install --no-interaction --no-suggest

.PHONY: cs-test
cs-test:
	$(call CS_FIXER_TEST,$(call PHP_FILES_DIFF,"origin/master"))

.PHONY: cs-fix
cs-fix:
	$(call CS_FIXER_FIX,$(call PHP_FILES_DIFF,"origin/master"))

.PHONY: psalm
psalm:
	$(PSALM)

.PHONY: psalm-report
psalm-report:
	$(PSALM) --report-show-info=false --report=$(PSALM_REPORT_FILE)

.PHONY: test
test:
	$(PHPUNIT)

.PHONY: show-coverage
show-coverage:
	$(PHPUNIT) --coverage-text=php://stdout

.PHONY: report-coverage
report-coverage:
	$(PHPUNIT) --coverage-clover $(CLOVER_FILE)

.PHONY: report-html-coverage
report-html-coverage:
	$(PHPUNIT) --coverage-html $(COVERAGE_REPORT_DIR)

.PHONY: upload-coverage
upload-coverage:
	$(SCRUTINIZER) --format=clover $(CLOVER_FILE)
