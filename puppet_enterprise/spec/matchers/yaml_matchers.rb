RSpec::Matchers.define :have_yaml_file do |file, hash|
  match_for_should do |catalog|
    if resource = catalogue.resource('File', file)
      if content = resource['content']
        yaml = YAML.load(content)
        hash.all? do |k,v|
          yaml.key?(k) && yaml[k] == v
        end
      end
    end
  end

  match_for_should_not do |str|
    if resource = catalog.resource('File', file)
      if content = resource['content']
        yaml = YAML.load(content)
        ! hash.any? do |k,v|
          yaml.key?(k) && yaml[k] == v
        end
      else
        true
      end
    else
      true
    end
  end

  failure_message_for_should do |str|
    "expected catalog to have YAML file #{file} with keys #{hash}"
  end

  failure_message_for_should_not do |step|
    "expected catalog not to have YAML file #{file} with keys #{hash}"
  end
end
