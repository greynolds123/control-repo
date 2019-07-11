# This file was automatically generated on 2019-06-08 13:59:54 -0700.
# Use the 'puppet generate types' command to regenerate this file.

# This type provides the capability to manage firewall rules within
# puppet.
# 
# **Autorequires:**
# 
# If Puppet is managing the iptables or ip6tables chains specified in the
# `chain` or `jump` parameters, the firewall resource will autorequire
# those firewallchain resources.
# 
# If Puppet is managing the iptables, iptables-persistent, or iptables-services packages,
# and the provider is iptables or ip6tables, the firewall resource will
# autorequire those packages to ensure that any required binaries are
# installed.
Puppet::Resource::ResourceType3.new(
  'firewall',
  [
    # Manage the state of this rule. The default action is *present*.
    # 
    # Valid values are `present`, `absent`.
    Puppet::Resource::Param(Enum['present', 'absent'], 'ensure'),

    # This is the action to perform on a match. Can be one of:
    # 
    # * accept - the packet is accepted
    # * reject - the packet is rejected with a suitable ICMP response
    # * drop - the packet is dropped
    # 
    # If you specify no value it will simply match the rule but perform no
    # action unless you provide a provider specific parameter (such as *jump*).
    # 
    # Valid values are `accept`, `reject`, `drop`.
    Puppet::Resource::Param(Enum['accept', 'reject', 'drop'], 'action'),

    # The source address. For example:
    # 
    #     source => '192.168.2.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     source => '! 192.168.2.0/24'
    # 
    # The source can also be an IPv6 address if your provider supports it.
    Puppet::Resource::Param(Any, 'source'),

    # The source IP range. For example:
    # 
    #     src_range => '192.168.1.1-192.168.1.10'
    # 
    # The source IP range must be in 'IP1-IP2' format.
    # 
    # 
    # 
    # Requires features iprange.
    Puppet::Resource::Param(Any, 'src_range'),

    # The destination address to match. For example:
    # 
    #     destination => '192.168.1.0/24'
    # 
    # You can also negate a mask by putting ! in front. For example:
    # 
    #     destination  => '! 192.168.2.0/24'
    # 
    # The destination can also be an IPv6 address if your provider supports it.
    Puppet::Resource::Param(Any, 'destination'),

    # The destination IP range. For example:
    # 
    #     dst_range => '192.168.1.1-192.168.1.10'
    # 
    # The destination IP range must be in 'IP1-IP2' format.
    # 
    # 
    # 
    # Requires features iprange.
    Puppet::Resource::Param(Any, 'dst_range'),

    # The source port to match for this filter (if the protocol supports
    # ports). Will accept a single element or an array.
    # 
    # For some firewall providers you can pass a range of ports in the format:
    # 
    #     <start_number>-<ending_number>
    # 
    # For example:
    # 
    #     1-1024
    # 
    # This would cover ports 1 to 1024.
    Puppet::Resource::Param(Any, 'sport'),

    # The destination port to match for this filter (if the protocol supports
    # ports). Will accept a single element or an array.
    # 
    # For some firewall providers you can pass a range of ports in the format:
    # 
    #     <start_number>-<ending_number>
    # 
    # For example:
    # 
    #     1-1024
    # 
    # This would cover ports 1 to 1024.
    Puppet::Resource::Param(Any, 'dport'),

    # DEPRECATED
    # 
    # The destination or source port to match for this filter (if the protocol
    # supports ports). Will accept a single element or an array.
    # 
    # For some firewall providers you can pass a range of ports in the format:
    # 
    #     <start_number>-<ending_number>
    # 
    # For example:
    # 
    #     1-1024
    # 
    # This would cover ports 1 to 1024.
    Puppet::Resource::Param(Any, 'port'),

    # The destination address type. For example:
    # 
    #     dst_type => 'LOCAL'
    # 
    # Can be one of:
    # 
    # * UNSPEC - an unspecified address
    # * UNICAST - a unicast address
    # * LOCAL - a local address
    # * BROADCAST - a broadcast address
    # * ANYCAST - an anycast packet
    # * MULTICAST - a multicast address
    # * BLACKHOLE - a blackhole address
    # * UNREACHABLE - an unreachable address
    # * PROHIBIT - a prohibited address
    # * THROW - undocumented
    # * NAT - undocumented
    # * XRESOLVE - undocumented
    # 
    # Valid values are `UNSPEC`, `! UNSPEC`, `UNICAST`, `! UNICAST`, `LOCAL`, `! LOCAL`, `BROADCAST`, `! BROADCAST`, `ANYCAST`, `! ANYCAST`, `MULTICAST`, `! MULTICAST`, `BLACKHOLE`, `! BLACKHOLE`, `UNREACHABLE`, `! UNREACHABLE`, `PROHIBIT`, `! PROHIBIT`, `THROW`, `! THROW`, `NAT`, `! NAT`, `XRESOLVE`, `! XRESOLVE`. 
    # 
    # Requires features address_type.
    Puppet::Resource::Param(Enum['UNSPEC', '! UNSPEC', 'UNICAST', '! UNICAST', 'LOCAL', '! LOCAL', 'BROADCAST', '! BROADCAST', 'ANYCAST', '! ANYCAST', 'MULTICAST', '! MULTICAST', 'BLACKHOLE', '! BLACKHOLE', 'UNREACHABLE', '! UNREACHABLE', 'PROHIBIT', '! PROHIBIT', 'THROW', '! THROW', 'NAT', '! NAT', 'XRESOLVE', '! XRESOLVE'], 'dst_type'),

    # The source address type. For example:
    # 
    #     src_type => 'LOCAL'
    # 
    # Can be one of:
    # 
    # * UNSPEC - an unspecified address
    # * UNICAST - a unicast address
    # * LOCAL - a local address
    # * BROADCAST - a broadcast address
    # * ANYCAST - an anycast packet
    # * MULTICAST - a multicast address
    # * BLACKHOLE - a blackhole address
    # * UNREACHABLE - an unreachable address
    # * PROHIBIT - a prohibited address
    # * THROW - undocumented
    # * NAT - undocumented
    # * XRESOLVE - undocumented
    # 
    # Valid values are `UNSPEC`, `! UNSPEC`, `UNICAST`, `! UNICAST`, `LOCAL`, `! LOCAL`, `BROADCAST`, `! BROADCAST`, `ANYCAST`, `! ANYCAST`, `MULTICAST`, `! MULTICAST`, `BLACKHOLE`, `! BLACKHOLE`, `UNREACHABLE`, `! UNREACHABLE`, `PROHIBIT`, `! PROHIBIT`, `THROW`, `! THROW`, `NAT`, `! NAT`, `XRESOLVE`, `! XRESOLVE`. 
    # 
    # Requires features address_type.
    Puppet::Resource::Param(Enum['UNSPEC', '! UNSPEC', 'UNICAST', '! UNICAST', 'LOCAL', '! LOCAL', 'BROADCAST', '! BROADCAST', 'ANYCAST', '! ANYCAST', 'MULTICAST', '! MULTICAST', 'BLACKHOLE', '! BLACKHOLE', 'UNREACHABLE', '! UNREACHABLE', 'PROHIBIT', '! PROHIBIT', 'THROW', '! THROW', 'NAT', '! NAT', 'XRESOLVE', '! XRESOLVE'], 'src_type'),

    # The specific protocol to match for this rule. By default this is
    # *tcp*.
    # 
    # Valid values are `tcp`, `! tcp`, `udp`, `! udp`, `icmp`, `! icmp`, `ipv6-icmp`, `! ipv6-icmp`, `esp`, `! esp`, `ah`, `! ah`, `vrrp`, `! vrrp`, `igmp`, `! igmp`, `ipencap`, `! ipencap`, `ipv4`, `! ipv4`, `ipv6`, `! ipv6`, `ospf`, `! ospf`, `gre`, `! gre`, `cbt`, `! cbt`, `sctp`, `! sctp`, `all`, `! all`.
    Puppet::Resource::Param(Enum['tcp', '! tcp', 'udp', '! udp', 'icmp', '! icmp', 'ipv6-icmp', '! ipv6-icmp', 'esp', '! esp', 'ah', '! ah', 'vrrp', '! vrrp', 'igmp', '! igmp', 'ipencap', '! ipencap', 'ipv4', '! ipv4', 'ipv6', '! ipv6', 'ospf', '! ospf', 'gre', '! gre', 'cbt', '! cbt', 'sctp', '! sctp', 'all', '! all'], 'proto'),

    # Match a given TCP MSS value or range.
    Puppet::Resource::Param(Any, 'mss'),

    # Match when the TCP flags are as specified.
    #       Is a string with a list of comma-separated flag names for the mask,
    #       then a space, then a comma-separated list of flags that should be set.
    #       The flags are: SYN ACK FIN RST URG PSH ALL NONE
    #       Note that you specify them in the order that iptables --list-rules
    #       would list them to avoid having puppet think you changed the flags.
    #       Example: FIN,SYN,RST,ACK SYN matches packets with the SYN bit set and the
    # ACK,RST and FIN bits cleared.  Such packets are used to request
    #                TCP  connection initiation.
    # 
    # 
    # 
    # Requires features tcp_flags.
    Puppet::Resource::Param(Any, 'tcp_flags'),

    # Name of the chain to use. Can be one of the built-ins:
    # 
    # * INPUT
    # * FORWARD
    # * OUTPUT
    # * PREROUTING
    # * POSTROUTING
    # 
    # Or you can provide a user-based chain.
    # 
    # The default value is 'INPUT'.
    # 
    # Values can match `/^[a-zA-Z0-9\-_]+$/`.
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Pattern[/^[a-zA-Z0-9\-_]+$/], 'chain'),

    # Table to use. Can be one of:
    # 
    # * nat
    # * mangle
    # * filter
    # * raw
    # * rawpost
    # 
    # By default the setting is 'filter'.
    # 
    # Valid values are `nat`, `mangle`, `filter`, `raw`, `rawpost`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Enum['nat', 'mangle', 'filter', 'raw', 'rawpost'], 'table'),

    # The value for the iptables --jump parameter. Normal values are:
    # 
    # * QUEUE
    # * RETURN
    # * DNAT
    # * SNAT
    # * LOG
    # * MASQUERADE
    # * REDIRECT
    # * MARK
    # 
    # But any valid chain name is allowed.
    # 
    # For the values ACCEPT, DROP and REJECT you must use the generic
    # 'action' parameter. This is to enfore the use of generic parameters where
    # possible for maximum cross-platform modelling.
    # 
    # If you set both 'accept' and 'jump' parameters, you will get an error as
    # only one of the options should be set.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'jump'),

    # Input interface to filter on.  Supports interface alias like eth0:0.
    # To negate the match try this:
    # 
    #       iniface => '! lo',
    # 
    # Values can match `/^!?\s?[a-zA-Z0-9\-\._\+\:]+$/`.
    # 
    # Requires features interface_match.
    Puppet::Resource::Param(Pattern[/^!?\s?[a-zA-Z0-9\-\._\+\:]+$/], 'iniface'),

    # Output interface to filter on.  Supports interface alias like eth0:0.
    # To negate the match try this:
    # 
    #       outiface => '! lo',
    # 
    # Values can match `/^!?\s?[a-zA-Z0-9\-\._\+\:]+$/`.
    # 
    # Requires features interface_match.
    Puppet::Resource::Param(Pattern[/^!?\s?[a-zA-Z0-9\-\._\+\:]+$/], 'outiface'),

    # When using jump => "SNAT" you can specify the new source address using
    # this parameter.
    # 
    # 
    # 
    # Requires features snat.
    Puppet::Resource::Param(Any, 'tosource'),

    # When using jump => "DNAT" you can specify the new destination address
    # using this paramter.
    # 
    # 
    # 
    # Requires features dnat.
    Puppet::Resource::Param(Any, 'todest'),

    # For DNAT this is the port that will replace the destination port.
    # 
    # 
    # 
    # Requires features dnat.
    Puppet::Resource::Param(Any, 'toports'),

    # For NETMAP this will replace the destination IP
    # 
    # 
    # 
    # Requires features netmap.
    Puppet::Resource::Param(Any, 'to'),

    # When using a jump value of "MASQUERADE", "DNAT", "REDIRECT", or "SNAT"
    # this boolean will enable randomized port mapping.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features dnat.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'random'),

    # When combined with jump => "REJECT" you can specify a different icmp
    # response to be sent back to the packet sender.
    # 
    # 
    # 
    # Requires features reject_type.
    Puppet::Resource::Param(Any, 'reject'),

    # When combined with jump => "LOG" specifies the system log level to log
    # to.
    # 
    # 
    # 
    # Requires features log_level.
    Puppet::Resource::Param(Any, 'log_level'),

    # When combined with jump => "LOG" specifies the log prefix to use when
    # logging.
    # 
    # 
    # 
    # Requires features log_prefix.
    Puppet::Resource::Param(Any, 'log_prefix'),

    # When combined with jump => "LOG" specifies the uid of the process making
    # the connection.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features log_uid.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'log_uid'),

    # When matching ICMP packets, this is the type of ICMP packet to match.
    # 
    # A value of "any" is not supported. To achieve this behaviour the
    # parameter should simply be omitted or undefined.
    # 
    # 
    # 
    # Requires features icmp_match.
    Puppet::Resource::Param(Any, 'icmp'),

    # Matches a packet based on its state in the firewall stateful inspection
    # table. Values can be:
    # 
    # * INVALID
    # * ESTABLISHED
    # * NEW
    # * RELATED
    # 
    # Valid values are `INVALID`, `ESTABLISHED`, `NEW`, `RELATED`. 
    # 
    # Requires features state_match.
    Puppet::Resource::Param(Enum['INVALID', 'ESTABLISHED', 'NEW', 'RELATED'], 'state'),

    # Matches a packet based on its state in the firewall stateful inspection
    # table, using the conntrack module. Values can be:
    # 
    # * INVALID
    # * ESTABLISHED
    # * NEW
    # * RELATED
    # 
    # Valid values are `INVALID`, `ESTABLISHED`, `NEW`, `RELATED`. 
    # 
    # Requires features state_match.
    Puppet::Resource::Param(Enum['INVALID', 'ESTABLISHED', 'NEW', 'RELATED'], 'ctstate'),

    # Match the Netfilter mark value associated with the packet.  Accepts either of:
    # mark/mask or mark.  These will be converted to hex if they are not already.
    # 
    # 
    # 
    # Requires features mark.
    Puppet::Resource::Param(Any, 'connmark'),

    # Connection limiting value for matched connections above n.
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features connection_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'connlimit_above'),

    # Connection limiting by subnet mask for matched connections.
    # IPv4: 0-32
    # IPv6: 0-128
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features connection_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'connlimit_mask'),

    # Hop limiting value for matched packets.
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features hop_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'hop_limit'),

    # Rate limiting value for matched packets. The format is:
    # rate/[/second/|/minute|/hour|/day].
    # 
    # Example values are: '50/sec', '40/min', '30/hour', '10/day'."
    # 
    # 
    # 
    # Requires features rate_limiting.
    Puppet::Resource::Param(Any, 'limit'),

    # Rate limiting burst value (per second) before limit checks apply.
    # 
    # Values can match `/^\d+$/`.
    # 
    # Requires features rate_limiting.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'burst'),

    # UID or Username owner matching rule.  Accepts a string argument
    # only, as iptables does not accept multiple uid in a single
    # statement.
    # 
    # 
    # 
    # Requires features owner.
    Puppet::Resource::Param(Any, 'uid'),

    # GID or Group owner matching rule.  Accepts a string argument
    # only, as iptables does not accept multiple gid in a single
    # statement.
    # 
    # 
    # 
    # Requires features owner.
    Puppet::Resource::Param(Any, 'gid'),

    # Match the Netfilter mark value associated with the packet.  Accepts either of:
    # mark/mask or mark.  These will be converted to hex if they are not already.
    # 
    # 
    # 
    # Requires features mark.
    Puppet::Resource::Param(Any, 'match_mark'),

    # Set the Netfilter mark value associated with the packet.  Accepts either of:
    # mark/mask or mark.  These will be converted to hex if they are not already.
    # 
    # 
    # 
    # Requires features mark.
    Puppet::Resource::Param(Any, 'set_mark'),

    # Sets the clamp mss to pmtu flag.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'clamp_mss_to_pmtu'),

    # Set DSCP Markings.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'set_dscp'),

    # This sets the DSCP field according to a predefined DiffServ class.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'set_dscp_class'),

    # Sets the TCP MSS value for packets.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'set_mss'),

    # Sets the packet type to match.
    # 
    # Valid values are `unicast`, `broadcast`, `multicast`. 
    # 
    # Requires features pkttype.
    Puppet::Resource::Param(Enum['unicast', 'broadcast', 'multicast'], 'pkttype'),

    # Set to true to match tcp fragments (requires type to be set to tcp)
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features isfragment.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'isfragment'),

    # Enable the recent module. Takes as an argument one of set, update,
    # rcheck or remove. For example:
    # 
    #   # If anyone's appeared on the 'badguy' blacklist within
    #   # the last 60 seconds, drop their traffic, and update the timestamp.
    #   firewall { '100 Drop badguy traffic':
    #     recent   => 'update',
    #     rseconds => 60,
    #     rsource  => true,
    #     rname    => 'badguy',
    #     action   => 'DROP',
    #     chain    => 'FORWARD',
    #   }
    #   # No-one should be sending us traffic on eth0 from localhost
    #   # Blacklist them
    #   firewall { '101 blacklist strange traffic':
    #     recent      => 'set',
    #     rsource     => true,
    #     rname       => 'badguy',
    #     destination => '127.0.0.0/8',
    #     iniface     => 'eth0',
    #     action      => 'DROP',
    #     chain       => 'FORWARD',
    #   }
    # 
    # Valid values are `set`, `update`, `rcheck`, `remove`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Enum['set', 'update', 'rcheck', 'remove'], 'recent'),

    # Recent module; add the destination IP address to the list.
    # Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'rdest'),

    # Recent module; add the source IP address to the list.
    # Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'rsource'),

    # Recent module; The name of the list. Takes a string argument.
    # 
    # 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Any, 'rname'),

    # Recent module; used in conjunction with one of `recent => 'rcheck'` or
    # `recent => 'update'`. When used, this will narrow the match to only
    # happen when the address is in the list and was seen within the last given
    # number of seconds.
    # 
    # 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Any, 'rseconds'),

    # Recent module; can only be used in conjunction with the `rseconds`
    # attribute. When used, this will cause entries older than 'seconds' to be
    # purged.  Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'reap'),

    # Recent module; used in conjunction with `recent => 'update'` or `recent
    # => 'rcheck'. When used, this will narrow the match to only happen when
    # the address is in the list and packets had been received greater than or
    # equal to the given value.
    # 
    # 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Any, 'rhitcount'),

    # Recent module; may only be used in conjunction with one of `recent =>
    # 'rcheck'` or `recent => 'update'`. When used, this will narrow the match
    # to only happen when the address is in the list and the TTL of the current
    # packet matches that of the packet which hit the `recent => 'set'` rule.
    # This may be useful if you have problems with people faking their source
    # address in order to DoS you via this module by disallowing others access
    # to your site by sending bogus packets to you.  Must be boolean true.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features recent_limiting.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'rttl'),

    # If true, matches if an open socket can be found by doing a coket lookup
    # on the packet.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features socket.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'socket'),

    # If true, matches if the packet has it's 'more fragments' bit set. ipv6.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features ishasmorefrags.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'ishasmorefrags'),

    # If true, matches if the packet is the last fragment. ipv6.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features islastfrag.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'islastfrag'),

    # If true, matches if the packet is the first fragment.
    # Sadly cannot be negated. ipv6.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features isfirstfrag.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'isfirstfrag'),

    # Sets the ipsec policy type. May take a combination of arguments for any flags that can be passed to `--pol ipsec` such as: `--strict`, `--reqid 100`, `--next`, `--proto esp`, etc.
    # 
    # Valid values are `none`, `ipsec`. 
    # 
    # Requires features ipsec_policy.
    Puppet::Resource::Param(Enum['none', 'ipsec'], 'ipsec_policy'),

    # Sets the ipsec policy direction
    # 
    # Valid values are `in`, `out`. 
    # 
    # Requires features ipsec_dir.
    Puppet::Resource::Param(Enum['in', 'out'], 'ipsec_dir'),

    # Set the matching mode for statistic matching. Supported modes are `random` and `nth`.
    # 
    # Valid values are `nth`, `random`.
    Puppet::Resource::Param(Enum['nth', 'random'], 'stat_mode'),

    # Match one packet every nth packet. Requires `stat_mode => 'nth'`
    Puppet::Resource::Param(Any, 'stat_every'),

    # Set the initial counter value for the nth mode. Must be between 0 and the value of `stat_every`. Defaults to 0. Requires `stat_mode => 'nth'`
    # 
    # Values can match `/^\d+$/`.
    Puppet::Resource::Param(Pattern[/^\d+$/], 'stat_packet'),

    # Set the probability from 0 to 1 for a packet to be randomly matched. It works only with `stat_mode => 'random'`.
    Puppet::Resource::Param(Any, 'stat_probability'),

    # Sets the mask to use when `recent` is enabled.
    # 
    # 
    # 
    # Requires features mask.
    Puppet::Resource::Param(Any, 'mask'),

    # The TEE target will clone a packet and redirect this clone to another
    # machine on the local network segment. gateway is the target host's IP.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'gateway'),

    # Matches against the specified ipset list.
    # Requires ipset kernel module.
    # The value is the name of the blacklist, followed by a space, and then
    # 'src' and/or 'dst' separated by a comma.
    # For example: 'blacklist src,dst'
    # 
    # 
    # 
    # Requires features ipset.
    Puppet::Resource::Param(Any, 'ipset'),

    # Compute and fill missing packet checksums.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'checksum_fill'),

    # MAC Source
    # 
    # Values can match `/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/i`.
    Puppet::Resource::Param(Pattern[/(?i-mx:^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$)/], 'mac_source'),

    # Match if the packet is entering a bridge from the given interface.
    # 
    # Values can match `/^[a-zA-Z0-9\-\._\+]+$/`.
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Pattern[/^[a-zA-Z0-9\-\._\+]+$/], 'physdev_in'),

    # Match if the packet is leaving a bridge via the given interface.
    # 
    # Values can match `/^[a-zA-Z0-9\-\._\+]+$/`.
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Pattern[/^[a-zA-Z0-9\-\._\+]+$/], 'physdev_out'),

    # Match if the packet is transversing a bridge.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'physdev_is_bridged'),

    # Only match during the given time, which must be in ISO 8601 "T" notation.
    # The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'date_start'),

    # Only match during the given time, which must be in ISO 8601 "T" notation.
    # The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'date_stop'),

    # Only match during the given daytime. The possible time range is 00:00:00 to 23:59:59.
    # Leading zeroes are allowed (e.g. "06:03") and correctly interpreted as base-10.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'time_start'),

    # Only match during the given daytime. The possible time range is 00:00:00 to 23:59:59.
    # Leading zeroes are allowed (e.g. "06:03") and correctly interpreted as base-10.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'time_stop'),

    # Only match on the given days of the month. Possible values are 1 to 31.
    # Note that specifying 31 will of course not match on months which do not have a 31st day;
    # the same goes for 28- or 29-day February.
    # 
    # 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Any, 'month_days'),

    # Only match on the given weekdays. Possible values are Mon, Tue, Wed, Thu, Fri, Sat, Sun.
    # 
    # Valid values are `Mon`, `Tue`, `Wed`, `Thu`, `Fri`, `Sat`, `Sun`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Enum['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], 'week_days'),

    # When time_stop is smaller than time_start value, match this as a single time period instead distinct intervals.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'time_contiguous'),

    # Use the kernel timezone instead of UTC to determine whether a packet meets the time regulations.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features iptables.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'kernel_timezone'),

    # Used with the CLUSTERIP jump target.
    # Create a new ClusterIP. You always have to set this on the first rule for a given ClusterIP.
    # 
    # Valid values are `true`, `false`. 
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Variant[Boolean, Enum['true', 'false']], 'clusterip_new'),

    # Used with the CLUSTERIP jump target.
    # Specify the hashing mode. Valid values: sourceip, sourceip-sourceport, sourceip-sourceport-destport.
    # 
    # Valid values are `sourceip`, `sourceip-sourceport`, `sourceip-sourceport-destport`. 
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Enum['sourceip', 'sourceip-sourceport', 'sourceip-sourceport-destport'], 'clusterip_hashmode'),

    # Used with the CLUSTERIP jump target.
    # Specify the ClusterIP MAC address. Has to be a link-layer multicast address.
    # 
    # Values can match `/^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$/i`.
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Pattern[/(?i-mx:^([0-9a-f]{2}[:]){5}([0-9a-f]{2})$)/], 'clusterip_clustermac'),

    # Used with the CLUSTERIP jump target.
    # Number of total nodes within this cluster.
    # 
    # Values can match `/\d+/`.
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Pattern[/\d+/], 'clusterip_total_nodes'),

    # Used with the CLUSTERIP jump target.
    # Specify the random seed used for hash initialization.
    # 
    # Values can match `/\d+/`.
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Pattern[/\d+/], 'clusterip_local_node'),

    # Used with the CLUSTERIP jump target.
    # Specify the random seed used for hash initialization.
    # 
    # 
    # 
    # Requires features clusterip.
    Puppet::Resource::Param(Any, 'clusterip_hash_init')
  ],
  [
    # The canonical name of the rule. This name is also used for ordering
    # so make sure you prefix the rule with a number:
    # 
    #     000 this runs first
    #     999 this runs last
    # 
    # Depending on the provider, the name of the rule can be stored using
    # the comment feature of the underlying firewall subsystem.
    # 
    # Values can match `/^\d+[[:graph:][:space:]]+$/`.
    Puppet::Resource::Param(Pattern[/^\d+[[:graph:][:space:]]+$/], 'name', true),

    # Read-only property for caching the rule line.
    Puppet::Resource::Param(Any, 'line'),

    # The specific backend to use for this `firewall`
    # resource. You will seldom need to specify this --- Puppet will usually
    # discover the appropriate provider for your platform.Available providers are:
    # 
    # ip6tables
    # : Ip6tables type provider
    # 
    #   * Required binaries: `ip6tables-save`, `ip6tables`.
    #   * Supported features: `address_type`, `connection_limiting`, `dnat`, `hop_limiting`, `icmp_match`, `interface_match`, `iprange`, `ipsec_dir`, `ipsec_policy`, `ipset`, `iptables`, `isfirstfrag`, `ishasmorefrags`, `islastfrag`, `log_level`, `log_prefix`, `log_uid`, `mark`, `mask`, `mss`, `owner`, `pkttype`, `rate_limiting`, `recent_limiting`, `reject_type`, `snat`, `socket`, `state_match`, `tcp_flags`.
    # 
    # iptables
    # : Iptables type provider
    # 
    #   * Required binaries: `iptables-save`, `iptables`.
    #   * Default for `kernel` == `linux`.
    #   * Supported features: `address_type`, `clusterip`, `connection_limiting`, `dnat`, `icmp_match`, `interface_match`, `iprange`, `ipsec_dir`, `ipsec_policy`, `ipset`, `iptables`, `isfragment`, `log_level`, `log_prefix`, `log_uid`, `mark`, `mask`, `mss`, `netmap`, `owner`, `pkttype`, `rate_limiting`, `recent_limiting`, `reject_type`, `snat`, `socket`, `state_match`, `tcp_flags`.
    Puppet::Resource::Param(Any, 'provider')
  ],
  {
    /(?m-ix:(.*))/ => ['name']
  },
  true,
  false)
