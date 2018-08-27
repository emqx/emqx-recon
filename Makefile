PROJECT = emqx_recon
PROJECT_DESCRIPTION = EMQ X Recon Plugin
PROJECT_VERSION = 3.0

DEPS = recon
dep_recon = git https://github.com/ferd/recon 2.3.6

BUILD_DEPS = emqx
dep_emqx = git https://github.com:emqtt/emqttd emqx30

TEST_DEPS = emqx_ct_helpers
dep_emqx_ct_helpers = git https://github.com/emqx/emqx-ct-helpers

NO_AUTOPATCH = cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +warnings_as_errors +warn_export_all +warn_unused_import
ERLC_OPTS += +'{parse_transform, lager_transform}'

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emqx_recon.conf -i priv/emqx_recon.schema -d data
