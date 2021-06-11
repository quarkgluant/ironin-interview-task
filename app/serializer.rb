class Serializer
  attr_reader :object
  @@fields = Hash.new { |h, k| h[k] = {} }

  def initialize(struct)
    @object = struct
  end

  def self.attribute(attribute_name, &attribute_bloc)
     @@fields[self.to_s][attribute_name] = attribute_bloc
  end

  def serialize
    @@fields[klass_name = self.class.to_s].keys.each_with_object({}) do |attribute_name, result|
      my_proc = @@fields[klass_name][attribute_name]
      value = my_proc.is_a?(Proc) ? instance_eval(&my_proc) : object.send(attribute_name)
      result[attribute_name] = value
    end
  end
end