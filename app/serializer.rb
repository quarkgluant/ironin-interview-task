class Serializer
  # class << self
  #   alias_method :attribute, :attr_accessor
  # end

  def initialize(body)
    @id = 1
    @body = body
  end

  def attribute(attr)
    attr
  end

  def serialize
    {
      id: @id,
      body: @body,
    }
  end
end
