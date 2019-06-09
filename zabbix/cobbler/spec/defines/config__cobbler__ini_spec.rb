describe "cobbler::config::ini" do
  let(:title) { 'config_file.ini' }
  context "with all default parameters" do
    let(:params) { {} }
    it {is_expected.to raise_error(Puppet::Error) }
  end
  context "with params set" do
    let(:params) {
      {
        'ensure'      => 'present',
        'config_file' => '/path/to/config_file.ini',
        'options'     => {
          'section1'            => {
            'option1' => 'value1',
            'option2' => [ 'value1', 'value2'],
          },
          'section2.subsection' => {
            'option3' => 'value3',
          }
        }
      }
    }
    context "ensure" do
      it "should support present value" do
        params.merge!({'ensure' => 'present'})
        should compile
      end
      it "should support absent value" do
        params.merge!({'ensure' => 'absent'})
        should compile
      end
    end
    it "raise error if config_file is not absolute path"  do
      params.merge!({'config_file' => 'not/an/absolute/path'})
      is_expected.to raise_error(Puppet::Error)
    end
    it "raise error if options is an hash"  do
      params.merge!({'options' => 'invalid_hash'})
      is_expected.to raise_error(Puppet::Error)
    end

    it { should contain_file('/path/to/config_file.ini').with(
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'content' => "# Managed by puppet\n[section1]\noption1 = value1\noption2 = value1\noption2 = value2\n\n[section2 \"subsection\"]\noption3 = value3\n\n",
    )
    }
  end
end
