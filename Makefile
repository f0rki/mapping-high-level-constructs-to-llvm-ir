# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = MappingHighLevelConstructstoLLVMIR
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

docker-run:
	# NOTE: The command below MUST be run using sudo: sudo make docker-run.
	docker run -w /app --mount type=bind,src="$(shell pwd)",target=/app llvm-ir sh -c "make $(SPHINXOPTS) $(O)"

docker-build:
	# NOTE: The command below MUST be run using sudo: sudo make docker-build.
	docker build --build-arg=NATIVE_UID=$(id -u ${USER}) --build-arg=NATIVE_GID=$(id -g ${USER}) -t llvm-ir .
