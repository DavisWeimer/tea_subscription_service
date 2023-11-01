# frozen_string_literal: true

class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :price, :status, :frequency, :customer_id, :tea_id
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
