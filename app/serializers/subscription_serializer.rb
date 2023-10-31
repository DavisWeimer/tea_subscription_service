# frozen_string_literal: true

class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :price, :status, :frequency, :customer_id, :tea_id
end
