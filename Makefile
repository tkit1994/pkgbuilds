all: nvtake
.PHONY: nvchecker 
nvchecker:
	nvchecker -c nvchecker.toml
.PHONY: nvtake
nvtake: nvchecker
	nvtake -c nvchecker.toml --all
.PHONY: clean 
clean:
	git clean -xdf
