RSpec::Matchers.define :contain_augeas_with_changes do |augeas_title, changes|
  match_for_should do |catalog|
    if resource = catalogue.resource('Augeas', augeas_title)
      if change = resource['changes']
        if changes.kind_of?(String)
          change.include?(changes)
        elsif changes.kind_of?(Array)
          (changes-change).empty?
        else
          @error_msg = 'changes should be of type String or Array'
          false
        end
      end
    end
  end

  failure_message_for_should do |str|
    @error_msg ||= "expected catalog to have augeas resource [#{augeas_title}] with changes #{changes}"
  end
end
