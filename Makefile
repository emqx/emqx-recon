PROJECT = emqttd_recon
PROJECT_DESCRIPTION = emqttd recon plugin
PROJECT_VERSION = 1.1

DEPS = recon emqttd

dep_recon  = git https://github.com/ferd/recon 2.2.1
dep_emqttd = git https://github.com/emqtt/emqttd plus

COVER = true

include erlang.mk

app:: rebar.config
