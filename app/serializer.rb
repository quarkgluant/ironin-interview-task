class Serializer
  # class << self
  #   alias_method :attribute, :attr_accessor
  # end
  attr_reader :object
  def initialize(struct)
    @struct = p struct
    struct.members.each do |member|
      define_singleton_method member do
        struct.dig member
      end
    end
    # define_singleton_method object do
    #   struct.class
    # end
    # @id = struct[:id]
    # @body = struct[:body]
  end



  def self.attribute(attr)
    if block_given?
      yield
    else
      attr
    end
  end

  def serialize
    @struct.to_h
    # {
    #   id: id,
    #   body: body,
    # }
  end
end
