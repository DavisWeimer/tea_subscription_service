# Tea Subscription Service API
![Tests](https://badgen.net/badge/tests/passing/green?icon=github)
![Commits](https://badgen.net/github/last-commit/DavisWeimer/tea_subscription_service?icon=github)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

Tea Subscription Service provides functionality for: 
- Managing tea subscriptions
- Allowing users to create and cancel subscriptions
- View their subscription history

## Ruby/Rails version<br>
`Ruby 3.2.2`<br>
`Rails 7.0.8`

## Built with<br>
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white)
![Postgresql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)
![Postman Badge](https://img.shields.io/badge/Postman-FF6C37?logo=postman&logoColor=fff&style=for-the-badge)

Getting Started
-------------
To get a local copy, follow these steps

## <b>Installation</b>

1. Fork the Project
2. Clone the repo (SSH) 
```shell 
git@github.com:DavisWeimer/tea_subscription_service.git 
```
3. Install the gems
```ruby
bundle install
```
4. Create the database
```ruby
rails db:{drop,create,migrate,seed}
```

## <b>Endpoints Available</b>
### 1. Subscribe a customer to a tea subscription
Request:
```shell
POST /api/v0/subscriptions
Content-Type: application/json
Accept: application/json
```
Body:
```json
{
    "title": "Monthly Black Tea",
    "price": 10.99,
    "status": "active",
    "frequency": 30,
    "customer_id": 1,
    "tea_id": 2
}
```
Response: `status: 201`
```json
{
    "data": {
        "id": "1",
        "type": "subscription",
        "attributes": {
            "id": 1,
            "title": "Monthly Black Tea",
            "price": 10.99,
            "status": "active",
            "frequency": 30,
            "customer_id": 1,
            "tea_id": 2
        }
    }
}
```

### 2. Cancel a customer’s tea subscription
Request:
```shell
DELETE /api/v0/subscriptions/1
Content-Type: application/json
Accept: application/json
```
Response: `status: 200`
```json
{
    "message": "Subscription successfully cancelled"
}
```

### 3. See all of a customer’s subscriptions
Request:
```shell
GET /api/v0/subscriptions
Content-Type: application/json
Accept: application/json
```
Body:
```json
{
    "customer_id": 1
}
```
Response: `status: 200`
```json
{
    "data": [
        {
            "id": "1",
            "type": "subscription",
            "attributes": {
                "id": 1,
                "title": "Monthly Black Tea",
                "price": 10.99,
                "status": "cancelled",
                "frequency": 30,
                "customer_id": 1,
                "tea_id": 2
            }
        },
        {
            "id": "2",
            "type": "subscription",
            "attributes": {
                "id": 2,
                "title": "Monthly Black Tea",
                "price": 10.99,
                "status": "cancelled",
                "frequency": 30,
                "customer_id": 1,
                "tea_id": 2
            }
        }
    ]
}
```
