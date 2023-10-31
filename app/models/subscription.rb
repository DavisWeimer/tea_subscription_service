# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :tea

  validates :title, :price, :frequency, presence: true

  enum status: %w[active cancelled]
end
