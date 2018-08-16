# This is a spec/unit test for the history class.

  require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"
  require 'spec_helper'
  describe 'history::config', :type => 'class'  do
  it { should contain_file('/etc/profile.d/history.sh').with_ensure('present') }
  end
  if { should contain_file('history.sh').with(
      :path  => '/etc/profile.d/history.sh',
  )}
