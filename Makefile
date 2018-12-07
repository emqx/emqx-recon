PROJECT = emqx_recon
PROJECT_DESCRIPTION = EMQ X Recon Plugin
PROJECT_VERSION = 3.0
PROJECT_MOD = emqx_recon

DEPS = recon
dep_recon = git-emqx https://github.com/ferd/recon 2.3.6

BUILD_DEPS = emqx
dep_emqx = git-emqx https://github.com/emqx/emqx emqx30

TEST_DEPS = emqx_ct_helpers
dep_emqx_ct_helpers = git https://github.com/emqx/emqx-ct-helpers

NO_AUTOPATCH = cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +warnings_as_errors +warn_export_all +warn_unused_import

COVER = true
$(shell [ -f erlang.mk ] || curl -s -o erlang.mk https://raw.githubusercontent.com/emqx/erlmk/master/erlang.mk)
include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emqx_recon.conf -i priv/emqx_recon.schema -d data
