#!/bin/bash
curl -s https://install.zerotier.com/ | sudo bash &> /dev/null

if [ -f /usr/sbin/zerotier-one ]; then
    # ZeroTier is installed, let's join some network(s)

    # my current networks
    networks=(`/usr/sbin/zerotier-cli listnetworks | awk '{print $3}' | sed -n '1!p' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g'`)

    for var in "$@"; do
        # remove all special chars from listed items
        var=$(sed 's/[,|;]//' <<< $var) 

        # join the network
        /usr/sbin/zerotier-cli join "$var" > /dev/null

        # remove network from list
        for target in "${var[@]}"; do
            for i in "${!networks[@]}"; do
                if [[ ${networks[i]} = ${var[0]} ]]; then
                    unset 'networks[i]'
                fi
            done
        done
    done

    # leave networks not supplied anymore
    for var in "${networks[@]}"; do
        /usr/sbin/zerotier-cli leave "$var" > /dev/null
    done
      
fi

cat /var/lib/zerotier-one/identity.public | cut -d : -f 1