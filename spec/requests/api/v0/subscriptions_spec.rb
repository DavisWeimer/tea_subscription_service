# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  before do
    @customer = Customer.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', address: '123 Main St')
    @tea = Tea.create(title: 'Black Tea', description: 'Strong and bold', temperature: 90, brew_time: 5)
    @sub = Subscription.create(title: 'Monthly Black Tea', price: 10.99, status: 'active', frequency: 30, customer: @customer, tea: @tea)

    tea2 = Tea.create(title: 'Green Tea', description: 'Light and refreshing', temperature: 80, brew_time: 3)
    tea3 = Tea.create(title: 'Oolong Tea', description: 'Semi-fermented, floral aroma', temperature: 85, brew_time: 4)
    tea4 = Tea.create(title: 'Herbal Tea', description: 'Caffeine-free, various flavors', temperature: 95, brew_time: 6)
    tea5 = Tea.create(title: 'White Tea', description: 'Delicate and subtle', temperature: 70, brew_time: 2)
    Subscription.create(title: 'Monthly Black Tea', price: 10.99, status: 'active', frequency: 30, customer: @customer, tea: @tea)
    Subscription.create(title: 'Bi-weekly Green Tea', price: 8.99, status: 'cancelled', frequency: 14, customer: @customer, tea: tea2)
    Subscription.create(title: 'Weekly Oolong Tea', price: 12.99, status: 'active', frequency: 7, customer: @customer, tea: tea3)
    Subscription.create(title: 'Monthly Herbal Tea', price: 9.99, status: 'active', frequency: 30, customer: @customer, tea: tea4)
    Subscription.create(title: 'Bi-weekly White Tea', price: 11.99, status: 'active', frequency: 14, customer: @customer, tea: tea5)
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
      delete api_v0_subscription_path(@sub.id), headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)

      @sub.reload

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Subscription successfully cancelled")
      expect(@sub.status).to eq('cancelled')
    end
  end

  describe 'DESTROY — Sad Path' do
    it "can't find Customer with incorrect ID" do
      delete api_v0_subscription_path(12492), headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:not_found)

      @sub.reload

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors][0][:detail]).to eq("Couldn't find Subscription with 'id'=12492")
      expect(@sub.status).to eq('active')
    end
  end

  describe 'GET — Happy Path' do
    it "returns all Customer Subscriptions" do
      customer_params = {
        customer_id: @customer.id
      }

      get api_v0_subscriptions_path, params: customer_params,
                                    headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)

      subscriptions = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions).to be_a Hash
      expect(subscriptions.keys).to contain_exactly(:data)
      
      subscriptions[:data].each do |subscription|
        expect(subscription.keys).to contain_exactly(:type, :id, :attributes)
        expect(subscription[:attributes].keys).to contain_exactly(:id, :title, :price, :status, :frequency, :customer_id, :tea_id)
        expect(subscription[:attributes][:id]).to be_a Integer
        expect(subscription[:attributes][:title]).to be_an String
        expect(subscription[:attributes][:price]).to be_a Float
        expect(subscription[:attributes][:status]).to be_a String
        expect(subscription[:attributes][:frequency]).to be_a Integer
        expect(subscription[:attributes][:customer_id]).to be_a Integer
        expect(subscription[:attributes][:tea_id]).to be_a Integer
      end
    end
  end

  describe 'GET — Sad Path' do
    it "can't return Customer Subscriptions without ID" do
      incorrect_params = {
        customer_id: 44135
      }

      get api_v0_subscriptions_path, params: incorrect_params,
                                    headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:errors][0][:detail]).to eq("Couldn't find Customer with 'id'=44135")
    end
  end
end