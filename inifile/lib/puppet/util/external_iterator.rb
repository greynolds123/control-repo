<<<<<<< HEAD
module Puppet
module Util
=======
module Puppet::Util
  #
  # external_iterator.rb
  #
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
  class ExternalIterator
    def initialize(coll)
      @coll = coll
      @cur_index = -1
    end

    def next
<<<<<<< HEAD
      @cur_index = @cur_index + 1
=======
      @cur_index += 1
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
      item_at(@cur_index)
    end

    def peek
      item_at(@cur_index + 1)
    end

    private
<<<<<<< HEAD
=======

>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
    def item_at(index)
      if @coll.length > index
        [@coll[index], index]
      else
        [nil, nil]
      end
    end
  end
end
<<<<<<< HEAD
end
=======
>>>>>>> 358c2d5599e3b70bbdd5e12ad751d558ed2fc6b8
