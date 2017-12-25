PROJECT = emq_recon
PROJECT_DESCRIPTION = Recon Plugin
PROJECT_VERSION = 2.3.2

DEPS = recon clique
dep_recon  = git https://github.com/ferd/recon 2.3.2
dep_clique = git https://github.com/emqtt/clique

BUILD_DEPS = emqttd cuttlefish
dep_emqttd = git https://github.com/emqtt/emqttd master
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

NO_AUTOPATCH = cuttlefish

ERLC_OPTS += +debug_info
ERLC_OPTS += +'{parse_transform, lager_transform}'

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emq_recon.conf -i priv/emq_recon.schema -d data
