# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  before do
    @customer = Customer.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', address: '123 Main St')
    @tea = Tea.create(title: 'Black Tea', description: 'Strong and bold', temperature: 90, brew_time: 5)
    @sub = Subscription.create(title: 'Monthly Black Tea', price: 10.99, status: 'active', frequency: 30, customer: @customer, tea: @tea)
  end

  describe 'CREATE — Happy Path' do
    it 'creates a Subscription for a Customer' do
      subscription_params = {
        title: 'Monthly Black Tea',
        price: 10.99,
        status: 'active',
        frequency: 30,
        customer_id: @customer.id,
        tea_id: @tea.id
      }

      post api_v0_subscriptions_path, params: subscription_params.to_json,
                                      headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:created)

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(subscription).to be_a Hash
      expect(subscription.keys).to contain_exactly(:data)
      expect(subscription[:data].keys).to contain_exactly(:type, :id, :attributes)
      expect(subscription[:data][:attributes].keys).to contain_exactly(:id, :title, :price, :status, :frequency,
                                                                       :customer_id, :tea_id)

      expect(subscription[:data][:attributes][:id]).to be_a Integer
      expect(subscription[:data][:attributes][:title]).to be_an String
      expect(subscription[:data][:attributes][:price]).to be_a Float
      expect(subscription[:data][:attributes][:status]).to be_a String
      expect(subscription[:data][:attributes][:frequency]).to be_a Integer
      expect(subscription[:data][:attributes][:customer_id]).to be_a Integer
      expect(subscription[:data][:attributes][:tea_id]).to be_a Integer
    end
  end

  describe 'CREATE — Sad Path' do
    it "can't create with incorrect params" do
      incorrect_params = {
        title: nil,
        price: nil,
        status: 'active',
        frequency: nil,
        customer_id: @customer.id,
        tea_id: @tea.id
      }

      post api_v0_subscriptions_path, params: incorrect_params.to_json,
                                      headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)

      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors[:title]).to eq(["can't be blank"])
      expect(errors[:price]).to eq(["can't be blank"])
      expect(errors[:frequency]).to eq(["can't be blank"])
    end
  end

  describe 'DESTROY — Happy Path' do
    it "can Cancel a Customers Subscription" do
      
      delete_params = {
        subscription_id: @sub.id
      }

      delete api_v0_subscription_path(@sub.id), params: delete_params.to_json,
                                        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)

      @sub.reload

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Subscription successfully cancelled")
      expect(@sub.status).to eq('cancelled')
    end
  end

  describe 'DESTROY — Sad Path' do
    it "can't find Customer with incorrect ID" do
      
      incorrect_params = {
        subscription_id: 12492
      }
      
      delete api_v0_subscription_path(@sub.id), params: incorrect_params.to_json,
                                        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:not_found)

      @sub.reload

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors][0][:detail]).to eq("Couldn't find Subscription with 'id'=12492")
      expect(@sub.status).to eq('active')
    end
  end
end
