class Address < SimpleObject
  transform_keys(&:to_sym)

  attribute? :line_1, Types::String.optional
  attribute? :line_2, Types::String.optional
  attribute? :city, Types::String.optional
  attribute? :state, Types::String.optional
  attribute? :country, Types::String.optional
end
