# class Serializer
  # # class << self
  # #   alias_method :attribute, :attr_accessor
  # # end
  # # attr_reader :object
  # @@attributes = []
  # def initialize(struct)
  #   @struct = struct
  #   @klass = struct.class
  #   p @klass
  #   @@attributes << @klass
  #   p @@attributes
  #   struct.members.each do |member|
  #     define_singleton_method member do
  #       struct.dig member
  #     end
  #   end
  #   # define_singleton_method :object do
  #   #   struct.class
  #   # end
  #   # @id = struct[:id]
  #   # @body = struct[:body]
  # end
  #
  #
  #
  # def self.attribute(attr)
  #   if block_given?
  #
  #   else
  #     @@attributes.first.dig(attr)
  #   end
  # end
  #
  # def serialize
  #   @struct.to_h
  # end
class Serializer
  attr_reader :struct
  @@fields = []

  def initialize(struct)

    @struct = struct
    # je crée des accesseurs pour chaque membre
    puts "struct.class: #{struct.class} "
    struct.members.each do |member|
      struct.class.define_singleton_method member do
        struct.dig member
      end
    end
    puts "############## #{struct.class}.methods: #{struct.class.methods(false)}  ############################"
  end

  def self.attribute(attribute_name, &block)
    # je récupère le nom de la classe sans le suffixe 'Serializer'
    klass_name = self.to_s.delete_suffix('Serializer')
    puts "-------------- self.to_s.delete_suffix('Serializer') #{self.to_s.delete_suffix('Serializer')} -----"
    # je crée une classe de type Post ou Comment
    object = Object.const_get(klass_name)
    puts "############## #{object.class}.methods: #{object.class.methods(false)}  ############################"
    puts "############## #{object}.methods: #{object.methods(false)}  ############################"

    # puts "############## object.class.members #{object.class.members}  ############################"
    # result = object.send attribute_name
    # # result = object.dig("#{attribute_name}")
    # puts "+++++++++++ #{result}"
    # result = yield object if block_given?
    my_proc = proc { |object| block.call(object) } if block
    @@fields << { self.to_s  => [attribute_name, object, my_proc] }
  end

  def serialize
    @@fields.each_with_object({}) do |hash_field, hash|
      puts " --- in serialize ---"
      hash_field.keys.each do |klass_name|
        if self.class.name == klass_name.to_s
          attr, object, my_proc = hash_field[klass_name]
          puts "#{my_proc}.is_a?(Proc) : #{my_proc.is_a?(Proc)} "
          result = my_proc.call(object) if my_proc.is_a?(Proc)
          result = object.send attr unless my_proc.is_a?(Proc)
          puts "result: #{result}"
          hash[attr] = result
        end
      end
    end
  end
end

  # def attributes(*attributes_list, &block)
  #   attributes_list = attributes_list.first if attributes_list.first.class.is_a?(Array)
  #   options = attributes_list.last.is_a?(Hash) ? attributes_list.pop : {}
  #   self.attributes_to_serialize = {} if attributes_to_serialize.nil?
  #
  #   # to support calling `attribute` with a lambda, e.g `attribute :key, ->(object) { ... }`
  #   block = attributes_list.pop if attributes_list.last.is_a?(Proc)
  #
  #   attributes_list.each do |attr_name|
  #     method_name = attr_name
  #     key = run_key_transform(method_name)
  #     attributes_to_serialize[key] = Attribute.new(
  #       key: key,
  #       method: block || method_name,
  #       options: options
  #     )
  #   end
  # end
  #
  # #----------------------------------------------------------------------------------------------
  #
  # def serializes(name)
  #   define_method(name) do   # provide a friendly-name accessor to the underlying resource
  #     resource
  #   end
  # end
  #
  # def expose(field, options = {})
  #   fields << Field.new(field, namespace, options)
  # end
  #
  # def namespace(ns = nil, &block)
  #   @namespace ||= []
  #   return @namespace if ns.nil?  # this method acts as both getter (this line) and setter (subsequent)
  #   @namespace.push(ns)
  #   block.call(binding)
  #   @namespace.pop
  # end
  #
  # def fields
  #   @fields ||= []
  # end
  #
  # #----------------------------------------------------------------------------------------------

