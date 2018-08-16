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
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  end
end
