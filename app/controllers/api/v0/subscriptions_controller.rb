# frozen_string_literal: true

module Api
  module V0
    class SubscriptionsController < ApplicationController
      rescue_from StandardError, with: :handle_error

      def create
        subscription = Subscription.new(subscription_params)

        if subscription.save
          render json: SubscriptionSerializer.new(subscription), status: :created
        else
          render json: subscription.errors, status: :unprocessable_entity
        end
      end

      def destroy
        subscription = Subscription.find(params[:subscription_id])
        subscription.update(status: 'cancelled')
        render json: { message: "Subscription successfully cancelled" }, status: :ok
      end

      def index
        customer = Customer.find(params[:customer_id])
        subscriptions = customer.subscriptions
        render json: SubscriptionSerializer.new(subscriptions), status: :ok
      end

      private

      def subscription_params
        params.require(:subscription).permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
      end

      def handle_error(exception)
        render json: { errors: [{ detail: exception.message }] }, status: :not_found
      end
    end
  end
end
