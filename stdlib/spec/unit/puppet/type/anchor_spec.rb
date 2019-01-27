<<<<<<< HEAD
#!/usr/bin/env ruby

require 'spec_helper'

anchor = Puppet::Type.type(:anchor).new(:name => "ntp::begin")

describe anchor do
  it "should stringify normally" do
    expect(anchor.to_s).to eq("Anchor[ntp::begin]")
=======
require 'spec_helper'

anchor = Puppet::Type.type(:anchor).new(:name => 'ntp::begin')

describe anchor do
  it 'stringifies normally' do
    expect(anchor.to_s).to eq('Anchor[ntp::begin]')
>>>>>>> f3fab20366c13fba7b36956f886163721fed8b19
  end
end
