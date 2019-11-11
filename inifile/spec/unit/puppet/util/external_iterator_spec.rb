require 'spec_helper'
require 'puppet/util/external_iterator'

describe Puppet::Util::ExternalIterator do
<<<<<<< HEAD
  let(:subject) { Puppet::Util::ExternalIterator.new(["a", "b", "c"]) }

  context "#next" do
    it "should iterate over the items" do
      subject.next.should == ["a", 0]
      subject.next.should == ["b", 1]
      subject.next.should == ["c", 2]      
    end
  end

  context "#peek" do
    it "should return the 0th item repeatedly" do
      subject.peek.should == ["a", 0]
      subject.peek.should == ["a", 0]
    end
    
    it "should not advance the iterator, but should reflect calls to #next" do
      subject.peek.should == ["a", 0]
      subject.peek.should == ["a", 0]
      subject.next.should == ["a", 0]
      subject.peek.should == ["b", 1]
      subject.next.should == ["b", 1]
      subject.peek.should == ["c", 2]
      subject.next.should == ["c", 2]
      subject.peek.should == [nil, nil]
      subject.next.should == [nil, nil]
    end
  end


=======
  subject_class = nil
  expected_values = nil

  before(:each) do
    subject_class = described_class.new(['a', 'b', 'c'])
    expected_values = [['a', 0], ['b', 1], ['c', 2]]
  end

  context '#next' do
    it 'iterates over the items' do
      expected_values.each do |expected_pair|
        expect(subject_class.next).to eq(expected_pair)
      end
    end
  end

  context '#peek' do
    it 'returns the 0th item repeatedly' do
      (0..2).each do |_i|
        expect(subject_class.peek).to eq(expected_values[0])
      end
    end

    it 'does not advance the iterator, but should reflect calls to #next' do
      expected_values.each do |expected_pair|
        expect(subject_class.peek).to eq(expected_pair)
        expect(subject_class.peek).to eq(expected_pair)
        expect(subject_class.next).to eq(expected_pair)
      end
    end
  end
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
end
