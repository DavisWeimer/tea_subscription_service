# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Tea.destroy_all
Customer.destroy_all
Subscription.destroy_all

tea1 = Tea.create(title: 'Black Tea', description: 'Strong and bold', temperature: 90, brew_time: 5)
tea2 = Tea.create(title: 'Green Tea', description: 'Light and refreshing', temperature: 80, brew_time: 3)
tea3 = Tea.create(title: 'Oolong Tea', description: 'Semi-fermented, floral aroma', temperature: 85, brew_time: 4)
tea4 = Tea.create(title: 'Herbal Tea', description: 'Caffeine-free, various flavors', temperature: 95, brew_time: 6)
tea5 = Tea.create(title: 'White Tea', description: 'Delicate and subtle', temperature: 70, brew_time: 2)

customer1 = Customer.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', address: '123 Main St')
customer2 = Customer.create(first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com', address: '456 Elm St')
customer3 = Customer.create(first_name: 'Alice', last_name: 'Johnson', email: 'alice@example.com',
                            address: '789 Elm St')
customer4 = Customer.create(first_name: 'Bob', last_name: 'Williams', email: 'bob@example.com', address: '567 Oak Ave')

Subscription.create(title: 'Monthly Black Tea', price: 10.99, status: 'active', frequency: 30,
                    customer: customer1, tea: tea1)
Subscription.create(title: 'Bi-weekly Green Tea', price: 8.99, status: 'cancelled', frequency: 14,
                    customer: customer2, tea: tea2)
Subscription.create(title: 'Weekly Oolong Tea', price: 12.99, status: 'active', frequency: 7,
                    customer: customer3, tea: tea3)
Subscription.create(title: 'Monthly Herbal Tea', price: 9.99, status: 'active', frequency: 30,
                    customer: customer4, tea: tea4)
Subscription.create(title: 'Bi-weekly White Tea', price: 11.99, status: 'active', frequency: 14,
                    customer: customer1, tea: tea5)
