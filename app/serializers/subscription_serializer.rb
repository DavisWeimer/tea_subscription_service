# frozen_string_literal: true

class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :price, :status, :frequency, :customer_id, :tea_id 
  attributes :created_at do |date_time|
    date_time.created_at.strftime('%A, %B %d, %Y %H:%M:%S %Z')
  end
end
