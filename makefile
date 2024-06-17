MAKE_CACHE_DIR := build/make_cache
VPATH := $(MAKE_CACHE_DIR)
PROD_SRC_FILES := $(shell find lib -name *.dart -print)
TEST_SRC_FILES := $(shell find test -name *.dart -print)

.PHONY: flutter_pub_get

pre-commit: flutter_format flutter_analyze $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	@touch $(MAKE_CACHE_DIR)/$@

flutter_format: $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	fvm flutter format --line-length 120 lib/ test/ > /dev/null
	@touch $(MAKE_CACHE_DIR)/$@

flutter_analyze: br l10n $(PROD_SRC_FILES) $(TEST_SRC_FILES) | $(MAKE_CACHE_DIR)
	fvm flutter analyze --no-pub --fatal-warnings
	@touch $(MAKE_CACHE_DIR)/$@

clean:
	fvm flutter clean

get:
	fvm flutter pub get

br:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

l10n:
	fvm flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o local_keys.g.dart

setup:
	make clean get br l10n 

$(MAKE_CACHE_DIR):
	mkdir -p $@