class Context
  def initialize(default: {}, methods: {})
    @symbol_table = default
    @methods = methods
  end

  def set(identifier:, value:)
    @symbol_table[identifier.to_sym] = value
  end

  def get(identifier:, path: {})
    assert_defined!(identifier: identifier)
    @symbol_table[identifier.to_sym]
    root = @symbol_table[identifier.to_sym]
    child = root
    path.each{|segment|
      segment_name = segment.elements[1].text_value.to_sym
      if child.respond_to?(segment_name)
        child = child.send(segment_name)
      else
        raise "no"
      end
    }

    child
  end

  def call(method:, args:)
    assert_method_exists!(method: method)
    @methods[method.to_sym].call(*args)
  end

  private
  def assert_defined!(identifier:)
    raise "Undefined variable: #{identifier}" unless @symbol_table.has_key?(identifier.to_sym)
  end

  def assert_method_exists!(method:)
    raise "Undefined method: #{method}" unless @methods.has_key?(method.to_sym)
  end
end

class Aphorist
  def initialize(default: {}, methods: {})
    @parser = AphorismParser.new
    @context = Context.new(default: default, methods: methods)
  end

  def parse(rule:)
    parsed_rule = @parser.parse(rule)
    raise "Parse Error: #{@parser.failure_reason}" unless parsed_rule

    puts parsed_rule.inspect
  end

  def eval(rule:)
    parsed_rule = @parser.parse(rule)
    raise "Parse Error: #{rule}" unless parsed_rule

    parsed_rule.value(ctx: @context)
  end
end
