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

.PHONY: aurpublish
aurpublish:
	find . -maxdepth 1 -type d | xargs -i basename {}| grep -v "\." | xargs -i aurpublish {}
