
diff-php-files = $(shell git diff --name-only --diff-filter=ACMRTUXB $(1) | grep -iE \.php$)

cs-options = --config=.php_cs -v --using-cache=no --diff --diff-format=udiff --ansi

cs-fixer =										\
	if test "$(1)" ; then						\
		vendor/bin/php-cs-fixer fix $(2) $(1) ;	\
	else										\
		echo "Nothing to fix" ;					\
	fi ;

tmp-dir = build
logs-dir = $(tmp-dir)/logs

clover-file = $(logs-dir)/clover.xml
html-report-dir = $(logs-dir)/report

psalm-args =  --threads=1 --no-cache --find-dead-code=always
psalm-report-file = $(logs-dir)/psalm.local.json

all: clean install test lint
lint: psalm cs-test

clean:
	rm -dfR $(tmp-dir)

build:
	mkdir -p $(logs-dir)

install:
	composer install --no-interaction --prefer-source --no-suggest

cs-test:
	@$(call cs-fixer,$(call diff-php-files,"origin/master"),$(cs-options) --dry-run)

cs-fix:
	@$(call cs-fixer,$(call diff-php-files,"origin/master"),$(cs-options))

psalm:
	vendor/bin/psalm $(psalm-args)

psalm-report:
	vendor/bin/psalm $(psalm-args) --report-show-info=false --report=$(psalm-report-file)

test:
	vendor/bin/phpunit

show-coverage:
	vendor/bin/phpunit --coverage-text=php://stdout

report-coverage:
	vendor/bin/phpunit --coverage-clover $(clover-file)

report-html-coverage:
	vendor/bin/phpunit --coverage-html $(html-report-dir)

upload-coverage:
	vendor/bin/ocular code-coverage:upload --format=clover $(clover-file)

.PHONY: all lint cs-fix psalm-report show-coverage report-coverage report-html-coverage upload-coverage
