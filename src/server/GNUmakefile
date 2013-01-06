
SOURCES := $(wildcard *.ts)
TARGETS := $(patsubst %.ts,%.js,$(SOURCES))

all: $(TARGETS) tests

.PHONY: tests

tests:
	$(MAKE) -C tests

%.js: %.ts
	tsc $<

clean:
	$(RM) $(TARGETS)
	$(MAKE) -C tests clean