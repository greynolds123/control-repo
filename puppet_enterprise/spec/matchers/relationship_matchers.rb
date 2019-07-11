RSpec::Matchers.define :satisfy_all_relationships do
  match_for_should do |catalog|
    @missing_deps = catalogue.resources.map do |resource|
      [:before, :require, :notify, :subscribe].map do |param|
        if deps = resource[param]
          deps = [deps] unless deps.is_a? Array
          deps.select { |dep| ! catalogue.resource(dep.to_s) }.map { |dep| [resource, param, dep] }
        end
      end.flatten(1)
    end.flatten(1).compact

    @missing_deps.empty?
  end

  failure_message_for_should do |str|
    dep_str = @missing_deps.map do |a,rel,b|
      case rel
      when :before
        "#{a} -> #{b}"
      when :require
        "#{a} <- #{b}"
      when :notify
        "#{a} ~> #{b}"
      when :subscribe
        "#{a} <~ #{b}"
      end
    end.join("\n")

    "found unsatisfied dependencies: #{dep_str}"
  end
end
