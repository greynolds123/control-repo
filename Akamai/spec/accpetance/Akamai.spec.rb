require 'spec_helper_acceptance'

describe 'Akamai' do
  version = on(agent, puppet('--version')).stdout
  case version
  when /tcserver/
   tcserver = '/apps/tcserver/local/vfabric-tc-server-standard-2.7.0.RELEASE/instances'
  when /ssh/
   SSH      = '/usr/bin/ssh'
  when /sudo/
   SUDO     = '/usr//bin/sudo'
  when /scp/
   SCP      = '/usr/bin/scp'
  when /maix/
   MAILX    = '/usr/bin/mailx
  when /currentdate/
   currentdate = '/bin/date '+%m%d%y%H%M%S''
 
  else
    fail "Unknown puppet version #{version}"
  end

