PROJECT = emq_recon
PROJECT_DESCRIPTION = Recon Plugin
PROJECT_VERSION = 2.1.2

DEPS = recon

dep_recon = git https://github.com/ferd/recon 2.3.2

BUILD_DEPS = emqttd cuttlefish
dep_emqttd = git https://github.com/emqtt/emqttd develop
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

NO_AUTOPATCH = cuttlefish

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emq_recon.conf -i priv/emq_recon.schema -d data
