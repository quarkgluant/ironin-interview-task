class Serializer
  attr_reader :struct
  @@fields = []

  def initialize(struct)
    @struct = struct
  end

  def self.attribute(attribute_name)
    klass_name = self.to_s.delete_suffix('Serializer')
    klass = Object.const_get(klass_name)
    self.define_singleton_method('object') { klass }
    my_proc = proc { yield } if block_given?
    @@fields << { self.to_s  => [attribute_name, klass, my_proc] }
  end

  def serialize
    last_object = struct
    struct.members.each do |member|
      struct.class.define_singleton_method member do
        last_object.dig member
      end
    end
    @@fields.each_with_object({}) do |hash_field, hash|
      hash_field.keys.each do |klass_name|
        if self.class.name == klass_name.to_s
          attr, klass, my_proc = hash_field[klass_name]
          result = if my_proc.is_a?(Proc)
                     my_proc.call()
                   else
                     klass.send attr
                   end
          hash[attr] = result
        end
      end
    end
  end
end