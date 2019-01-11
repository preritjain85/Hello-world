# environment variables.
# for determining the build environment (local)

AT_MODE ?= local
TARGET_USER ?= nagios
TARGET_GROUP ?= $(or $(TARGET_USER),nagios)
SMTP_HOST ?= smtp.gmail.com
SMTP_PORT ?= 587
MAIL_ID ?= mail-id
MAIL_PASSWD ?= password

# os settings for branching.
OS_VERSION := $(shell lsb_release -a | grep Release | awk '{ split($$0,a,/s\+/); print $$2; }')
OS_NAME := $(if $(filter $(OS_VERSION),16.04),xenial,precise)

ARCH := x86_64-ubuntu
ARCH_OS_VERSION = $(ARCH)$(OS_VERSION)

# git settings.
GIT_SERVER ?= https://github.com
GIT_SERVER ?= $(GIT_SERVER)
GIT_BRANCH ?= $(if $(filter $(OS_VERSION),16.04),topic-ubuntu-18.04,master)

SITE_DIR := /site
NAGIOS_DIR := $(SITE_DIR)/$(Nagios)

# apt options
APT_OPTIONS := $(if $(filter $(OS_VERSION),16.04),-y,-y --force-yes)

# common functions.
# git_latest <repo_name>,<org_name>,<dir_name>

define git_latest
URL="$(GIT_SERVER)/$(or $(2),marchex)/$(1).git"; \
DEST="$(SITE_DIR)/$(or $(3),$(1))"; \
if [ -d $$DEST ]; then \
    if [ -d $$DEST/.git ]; then \
            cd $$DEST && git pull && cd -; \
else \
    rm -rf $$DEST && git clone $(GIT_CLONE_OPTIONS) $$URL $$DEST; \
fi; \
else \
git clone $(GIT_CLONE_OPTIONS) $$URL $$DEST; \
fi; \
sudo chown -R $(USER):$(TARGET_GROUP) $$DEST;
endef

define git_version
DEST="$(SITE_DIR)/$(1)" && cd $$DEST && git checkout $(2)
endef

define provision_systemd
sudo systemctl daemon-reload
sudo systemctl restart $(1).service
endef

define add_group
if ! getent group $(1) >/dev/null 2>&1; then \
sudo addgroup --system --gid 570 $(1); \
elif [ "g`getent group $(1) | cut -d: -f3`" != g570 ]; then \
echo "`hostname` has the wrong gid for the $(1) group" >&2; \
exit 1; \
fi
endef

define add_user
if ! getent passwd $(1) >/dev/null 2>&1; then \
sudo adduser --system --gid 570 --uid 604 --shell /bin/bash $(1); \
elif [ "u`id -u $(1)`g`id -g $(1)`" != u604g570 ]; then \
echo "`hostname` has the wrong uid/gid for the $(1) user" >&2; \
fi
endef

define apt_install
sudo apt-get install $(APT_OPTIONS) $(1)
endef

define apt_update
sudo apt-get update
endef

define apt_upgrade
sudo apt-get upgrade $(APT_OPTIONS)
endef

define apt_remove
sudo apt-get remove $(APT_OPTIONS) $(1)
endef

# 1 => director(ies)
# 2 => user
define set_permission
sudo chown -R $(or $(2),$(USER)):$(TARGET_GROUP) $(1)
sudo find $(1) -type d -exec chmod g+s '{}' \;
sudo chmod -R g+rw $(1)
endef

define set_permission_all
sudo chmod -R a+rw $(1)
sudo find $(1) -type d -exec chmod a+x '{}' \;
endef

define set_logs_permissions
$(call set_permission,$(ADTRACK_DIR)/logs)
endef

