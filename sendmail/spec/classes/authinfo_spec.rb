require 'spec_helper'

describe 'sendmail::authinfo' do

  it { should contain_class('sendmail::authinfo') }

  context 'with content => foo' do
    let(:params) do
      { :content => 'foo' }
    end

    it {
      should contain_class('sendmail::authinfo::file').with(
               'content' => 'foo',
               'source'  => nil,
             )
    }
  end

  context 'with source => foo' do
    let(:params) do
      { :source => 'foo' }
    end

    it {
      should contain_class('sendmail::authinfo::file').with(
               'content' => nil,
               'source'  => 'foo',
             )
    }
  end

  context 'with source and content set' do
    let(:params) do
      { :source => 'foo', :content => 'foo' }
    end

    it { expect { should compile }.to raise_error(/cannot specify more than/) }
  end

  context 'with source and entries set' do
    let(:params) do
      {
        :source  => 'foo',
        :entries => { 'example.com' => {
                        'authentication_id' => 'auth',
                        'password' => 'secret' }
                    }
      }
    end

    it { expect { should compile }.to raise_error(/cannot specify more than/) }
  end

  context 'with content and entries set' do
    let(:params) do
      {
        :content => 'foo',
        :entries => { 'example.com' => {
                        'authentication_id' => 'auth',
                        'password' => 'secret' }
                    }
      }
    end

    it { expect { should compile }.to raise_error(/cannot specify more than/) }
  end

  context 'with valid parameter hash' do
    let(:params) do
      {
        :entries => { 'example.com' => {
                        'authentication_id' => 'auth',
                        'password' => 'secret' }
                    }
      }
    end

    it { should contain_sendmail__authinfo__entry('example.com') }
  end

  context 'with empty parameter hash' do
    let(:params) do
      { :entries => { } }
    end

    it { expect { should compile } }
  end

  context 'with wrong parameter type' do
    let(:params) do
      { :entries => "example.com" }
    end

    it { expect { should compile }.to raise_error(/is not a Hash/) }
  end
end
