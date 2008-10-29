class Object
  def metaclass; (class << self; self; end); end

  def meta_def(name, &block)
    metaclass.instance_eval { define_method(name, &block) }
  end
end
