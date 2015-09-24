require "whitelist_scope/version"

module WhitelistScope
  attr_reader :whitelist

  def whitelist_scope(name, body)
    @whitelist ||= []
    name = name.to_sym

    if self.respond_to?(name)
      raise ArgumentError, "Could not create scope, There is an existing method with this name."
    end

    scope name, body
    @whitelist << name
  end

  def call_whitelisted_scope(*scope_names)
    scope_results = nil

    scope_names.flatten.each do |scope_name|
      scope_name = scope_name.to_sym unless scope_name == nil

      if @whitelist.include? scope_name
        if scope_results
          scope_results = scope_results.send(scope_name)
        else
          scope_results = self.send(scope_name)
        end
      else
        raise NoMethodError, "The scope you provided, '#{scope_name}', does not exist."
      end
    end
    scope_results
  end
end
