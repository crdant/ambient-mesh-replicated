PROJECT_DIR    := $(shell pwd)
CHANNEL        := development 
RELEASE_NOTES  := $(shell git log -1 --pretty=%B)

MANIFEST_DIR := $(PROJECT_DIR)/manifests
MANIFESTS    := $(shell find $(MANIFEST_DIR) -name '*.yaml' -o -name '*.tgz')
BUILD_DIR    := build

lint: $(MANIFESTS)
	@replicated release lint --yaml-dir $(MANIFEST_DIR)

release: $(MANIFESTS)
	@replicated release create \
		--app ${REPLICATED_APP} \
		--token ${REPLICATED_API_TOKEN} \
		--auto -y \
		--yaml-dir $(MANIFEST_DIR) \
		--promote $(CHANNEL) \
		--version $(VERSION) \
		--release-notes "$(RELEASE_NOTES)"

install:
	@kubectl kots install ${REPLICATED_APP}
