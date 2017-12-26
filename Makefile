PROJECT = emqx_recon
PROJECT_DESCRIPTION = EMQ X Recon Plugin
PROJECT_VERSION = 2.3.2

DEPS = recon clique
dep_recon  = git https://github.com/ferd/recon 2.3.2
dep_clique = git https://github.com/emqtt/clique

BUILD_DEPS = emqx cuttlefish
dep_emqx = git git@github.com:emqx/emqx-enterprise
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

NO_AUTOPATCH = cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +'{parse_transform, lager_transform}'

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emqx_recon.conf -i priv/emqx_recon.schema -d data
