nvchecker:
	nvchecker -c nvchecker.toml

nvtake:
	nvtake -c nvchecker.toml --all

clean:
	git clean -xdf