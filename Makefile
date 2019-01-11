include ./common/Makefile

#############################################################################
# system
# setup the basic system. works for both 
#############################################################################
.PHONY: user-only
user-only:
	$(call add_group,$(TARGET_GROUP))
	$(call add_user,$(TARGET_USER))
	sudo usermod -a -G $(TARGET_GROUP) $(USER) # add the current user to the group as well.

.PHONY: user
user: user-only

.PHONY: user-info
user-info:
	echo $(TARGET_USER), $(TARGET_GROUP)

.PHONY: os-version
os-version:
	echo $(OS_VERSION)

.PHONY: hostname-only
hostname-only:
	cat conf/etc/hostname | sudo tee /etc/hostname 
	sudo systemctl restart systemd-logind.service
	sudo hostname Nagios-local

# MAIN system
.PHONY: system
system: user
	cat conf/etc/hosts | sudo tee -a /etc/hosts 
	cat conf/etc/resolv.conf | sudo tee -a /etc/resolv.conf
	$(call apt_update)
	$(call apt_upgrade)
	$(call apt_install,lsb-core git apache2 apache2-dev libapache2-mod-apreq2 libapache2-mod-perl2 libapache2-mod-perl2-dev libperl-dev python-software-properties)
	curl -L https://cpanmin.us | perl - --sudo App::cpanminus
	sudo cpanm Apache2::Upload --notest
	sudo cpanm File::FindLib
	sudo chmod -R a+rx /usr/local/share/perl/ # do we really need this?
	sudo mkdir -p $(SITE_DIR)
	$(call set_permission,$(SITE_DIR),$(USER))
