PROJECT = emqx_recon
PROJECT_DESCRIPTION = EMQ X Recon Plugin
PROJECT_VERSION = 3.1
PROJECT_MOD = emqx_recon

DEPS = recon
dep_recon = git-emqx https://github.com/ferd/recon 2.3.6

CUR_BRANCH := $(shell git branch | grep -e "^*" | cut -d' ' -f 2)
BRANCH := $(if $(filter $(CUR_BRANCH), master develop testing), $(CUR_BRANCH), testing)

BUILD_DEPS = emqx
dep_emqx = git-emqx https://github.com/emqx/emqx $(BRANCH)

NO_AUTOPATCH = cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +warnings_as_errors +warn_export_all +warn_unused_import

COVER = true

$(shell [ -f erlang.mk ] || curl -s -o erlang.mk https://raw.githubusercontent.com/emqx/erlmk/master/erlang.mk)
include erlang.mk

CUTTLEFISH_SCRIPT = _build/default/lib/cuttlefish/cuttlefish

app.config: $(CUTTLEFISH_SCRIPT) etc/emqx_recon.conf
	$(verbose) $(CUTTLEFISH_SCRIPT) -l info -e etc/ -c etc/emqx_recon.conf -i priv/emqx_recon.schema -d data

$(CUTTLEFISH_SCRIPT): rebar-deps
	@if [ ! -f cuttlefish ]; then make -C _build/default/lib/cuttlefish; fi

distclean::
	@rm -rf _build cover deps logs log data
	@rm -f rebar.lock compile_commands.json cuttlefish

rebar-deps:
	rebar3 get-deps

rebar-clean:
	@rebar3 clean

rebar-compile: rebar-deps
	rebar3 compile

rebar-ct: app.config
	rebar3 ct

rebar-eunit: $(CUTTLEFISH_SCRIPT)
	@rebar3 eunit

rebar-xref:
	@rebar3 xref
