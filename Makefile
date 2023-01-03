all: nvtake

nvchecker:
	nvchecker -c nvchecker.toml

nvtake: nvchecker
	nvtake -c nvchecker.toml --all

clean:
	git clean -xdf

update:
	./update.sh

.PHONY: nvchecker clean update
