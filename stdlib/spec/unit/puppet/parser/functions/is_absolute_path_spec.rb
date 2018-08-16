require 'spec_helper'

<<<<<<< HEAD
describe :is_absolute_path do
=======
describe 'is_absolute_path' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  let(:function_args) do
    []
  end

  let(:function) do
    scope.function_is_absolute_path(function_args)
  end

<<<<<<< HEAD

  describe 'validate arity' do
    let(:function_args) do
       [1,2]
    end
    it "should raise a ParseError if there is more than 1 arguments" do
      lambda { function }.should( raise_error(ArgumentError))
    end

  end
  
  it "should exist" do
=======
  describe 'validate arity' do
    let(:function_args) do
      [1, 2]
    end

    it 'raises a ParseError if there is more than 1 arguments' do
      -> { function }.should(raise_error(ArgumentError))
    end
  end

  it 'exists' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    Puppet::Parser::Functions.function(subject).should == "function_#{subject}"
  end

  # help enforce good function defination
<<<<<<< HEAD
  it 'should contain arity' do

  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { function }.should( raise_error(ArgumentError))
  end


=======
  it 'contains arity' do
  end

  it 'raises a ParseError if there is less than 1 arguments' do
    -> { function }.should(raise_error(ArgumentError))
  end

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
  describe 'should retrun true' do
    let(:return_value) do
      true
    end

    describe 'windows' do
      let(:function_args) do
        ['c:\temp\test.txt']
      end
<<<<<<< HEAD
      it 'should return data' do
=======

      it 'returns data' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        function.should eq(return_value)
      end
    end

    describe 'non-windows' do
      let(:function_args) do
        ['/temp/test.txt']
      end

<<<<<<< HEAD
      it 'should return data' do
=======
      it 'returns data' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        function.should eq(return_value)
      end
    end
  end

  describe 'should return false' do
    let(:return_value) do
      false
    end
<<<<<<< HEAD
=======

>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
    describe 'windows' do
      let(:function_args) do
        ['..\temp\test.txt']
      end
<<<<<<< HEAD
      it 'should return data' do
=======

      it 'returns data' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        function.should eq(return_value)
      end
    end

    describe 'non-windows' do
      let(:function_args) do
        ['../var/lib/puppet']
      end
<<<<<<< HEAD
      it 'should return data' do
=======

      it 'returns data' do
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
        function.should eq(return_value)
      end
    end
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> cebd2f908c751349c9576e41139907f4fe36d870
