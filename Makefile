PROJECT = emq_recon
PROJECT_DESCRIPTION = Recon Plugin
PROJECT_VERSION = 2.0.1

DEPS = recon

dep_recon = git https://github.com/ferd/recon 2.2.1

BUILD_DEPS = emqttd
dep_emqttd = git https://github.com/emqtt/emqttd master

TEST_DEPS = cuttlefish
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

CT_SUITES = emq_recon
CT_OPTS = -erl_args -config test/config/sys.config

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	cuttlefish -l info -e etc/ -c etc/emq_recon.conf -i priv/emq_recon.schema -d data

