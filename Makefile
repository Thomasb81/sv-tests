all: report

OUT_DIR=./out/
CONF_DIR=./conf
TESTS_DIR=./tests
RUNNERS_DIR=./tools/runners
EXTERNAL_DIR=./external
GENERATORS_DIR=./generators

export OUT_DIR
export CONF_DIR
export EXTERNAL_DIR
export TESTS_DIR
export RUNNERS_DIR
export GENERATORS_DIR

include tools/runners.mk

.PHONY: clean init info tests generate-tests report

clean:
	@echo -e "Removing $(OUT_DIR)"
	@rm -rf $(OUT_DIR)
	@echo -e "Removing $(TESTS_DIR)/generated/"
	@rm -rf $(TESTS_DIR)/generated/

init:
ifneq (,$(wildcard $(OUT_DIR)/*))
	@echo -e "!!! WARNING !!!\nThe output directory is not empty\n"
endif

runners:

# $(1) - runner name
# $(2) - test
define runner_gen
$(OUT_DIR)/logs/$(1)/$(2).log: $(TESTS_DIR)/$(2)
	@mkdir -p $(OUT_DIR)/logs/$(1)/$(dir $(2))
	@./tools/runner --runner $(1) --test $(2)

tests: $(OUT_DIR)/logs/$(1)/$(2).log
endef

define generator_gen
generate-$(1):
	@mkdir -p $(TESTS_DIR)/generated/$(1)/
	@$(GENERATORS_DIR)/$(1) $(1)

generate-tests: generate-$(1)
endef

RUNNERS := $(wildcard $(RUNNERS_DIR)/*.py)
RUNNERS := $(RUNNERS:$(RUNNERS_DIR)/%=%)
RUNNERS := $(basename $(RUNNERS))
TESTS := $(shell find $(TESTS_DIR)/ -type f -iname *.sv)
TESTS := $(TESTS:$(TESTS_DIR)/%=%)
GENERATORS := $(wildcard $(GENERATORS_DIR)/*)
GENERATORS := $(GENERATORS:$(GENERATORS_DIR)/%=%)

space := $(subst ,, )

info:
	@echo -e "Found the following runners:$(subst $(space),"\\n \* ", $(RUNNERS))\n"
	@echo -e "Found the following tests:$(subst $(space),"\\n \* ", $(TESTS))\n"

tests:

generate-tests:

report: init info tests
	@echo -e "\nGenerating report"
	@./tools/sv-report
	@echo -e "\nDONE!"

$(foreach g, $(GENERATORS), $(eval $(call generator_gen,$(g))))
$(foreach r, $(RUNNERS),$(foreach t, $(TESTS),$(eval $(call runner_gen,$(r),$(t)))))
