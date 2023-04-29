# Minimal makefile for Sphinx documentation

# NOTE: You must either add the current user to the docker group (insecure)
# NOTE: or use 'sudo' as a prefix to make when you invoke any of the docker-*
# NOTE: commands.

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

# Build a new docker container with the name 'llvm-ir'.
docker-build:
	# NOTE: The command below requires sudo: sudo make docker-build
	docker build --build-arg=NATIVE_UID=$(id -u ${USER}) --build-arg=NATIVE_GID=$(id -g ${USER}) -t llvm-ir .

# Run Sphinx inside the docker container.
docker-make:
	# NOTE: The command below requires sudo: sudo make docker-make O=html
	docker run -w /app --mount type=bind,src="$(shell pwd)",target=/app llvm-ir sh -c "make $(SPHINXOPTS) $(O)"

# Run a command in the app folder inside the docker container.
docker-run:
	# NOTE: The command below requires sudo: sudo make docker-run O="ls -l"
	docker run --rm --interactive --tty --volume $(shell pwd):/app llvm-ir $(O)
