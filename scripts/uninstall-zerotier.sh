#!/bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin

if [ "$UID" -ne 0 ]; then
	echo "Must be run as root; try: sudo $0"
	exit 1
fi

if [ ! -f /usr/sbin/zerotier-one ]; then
	echo 'ZeroTier One does not seem to be installed.'
	exit 1
fi

SUDO=
if [ "$UID" != "0" ]; then
	if [ -e /usr/bin/sudo -o -e /bin/sudo ]; then
		SUDO=sudo
	else
		echo '*** This quick installer script requires root privileges.'
		exit 0
	fi
fi

echo '*** Detecting Linux Distribution'
echo

if [ -f /etc/debian_version ]; then
    # Uninstall software
	cat /dev/null | $SUDO apt-get purge -y zerotier-one
    # Remove repo
    cat /dev/null | $SUDO rm -f /etc/apt/sources.list.d/zerotier.list
    # TODO: remove key?
elif [ -f /etc/SuSE-release -o -f /etc/suse-release -o -f /etc/SUSE-brand -o -f /etc/SuSE-brand -o -f /etc/suse-brand ]; then
    # Uninstall software
	cat /dev/null | $SUDO zypper remove -y zerotier-one
    # Remove repo
	cat /dev/null | $SUDO zypper removerepo zerotier
    # TODO: remove key?
elif [ -d /etc/yum.repos.d ]; then
    # Uninstall software
	if [ -e /usr/bin/dnf ]; then
		cat /dev/null | $SUDO dnf remove -y zerotier-one
	else
		cat /dev/null | $SUDO yum remove -y zerotier-one
	fi
    # Remove repo
    cat /dev/null | $SUDO rm -f /etc/yum.repos.d/zerotier.repo
    # TODO: remove key?
fi
    
# remove leftover files
cat /dev/null | $SUDO rm -Rf /var/lib/zerotier-one