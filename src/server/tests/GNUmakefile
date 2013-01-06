
SOURCES := $(wildcard *.ts)
TARGETS := $(patsubst %.ts,%.js,$(SOURCES))

all: $(TARGETS)

%.js: %.ts
	tsc $<

clean:
	$(RM) $(TARGETS)
