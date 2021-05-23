# README

## Environment

```
ruby 2.6.6p146 (2020-03-31 revision 67876) [x86_64-linux-musl]
Rails 6.0.3.7
Linux version 5.4.72-microsoft-standard-WSL2 (oe-user@oe-host) (gcc version 8.2.0 (GCC))
```

## How to run app

- run app in local

```sh
# depend on a visited mysql
# url: mysql2://root:root@127.0.0.1

bundle install --path vendor/bundle
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails s -b 0.0.0.0 -p 9000
```

- run app in docker container

```sh
# TODO
```

## API

### Request Header

| Header | Type | Required | Description |
| :- | :- | :- | :- |
| Authorization | string | true  | JWT |

```sh
# payload = {user_id: 1}
# Rails.application.secret_key_base = 's3cr3t'
# JsonWebToken.encode(payload)
# If you want to test apis, you should add the next to request headers
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2MjI2NjE2NTd9.az6zUY7mCV0DIysC00LZsXsWSUJAdw3WkvD7I75MmFI
```

### General response

- Not authenticated

```json
{
  "code": 401
}
```

- Not found

```json
{
  "code": 404
}
```

### Check Balance

- URL: http://localhost:9000/balance/:user_id
- Type: GET

- Response

| Field | Type |
| :- | :- |
| code | int |
| balance | float |

```json
// success
{
  "code": 0,
  "balance": 100.00
}
```

### Fund In

- URL: http://localhost:9000/fund_in
- Type: POST
- Parameters

| Parameter | Type | Required | Description |
| :- | :- | :- | :- |
| user_id | string | true | user id |
| amount | string | true | amount of fund |

- Response

| Field | Type |
| :- | :- |
| code | int |
| fund_transaction_id | string |
| balance | float |

```json
// success
{
  "code": 0,
  "fund_transaction_id": "xxx",
  "balance": 100.00
}
```

### Fund Out

- URL: http://localhost:9000/fund_out
- Type: POST
- Parameters

| Parameter | Type | Required | Description |
| :- | :- | :- | :- |
| user_id | string | true | user id |
| amount | string | true | amount of fund |

- Response

| Field | Type |
| :- | :- |
| code | int |
| transaction_id | bigint |
| balance | float |

```json
// success
{
  "code": 0,
  "transaction_id": 1,
  "balance": 100.00
}

// not enough fund
{
  "code": 1,
  "balance": 90.00
}
```

### Transfer

- URL: http://localhost:9000/transfer
- Type: POST
- Parameters

| Parameter | Type | Required | Description |
| :- | :- | :- | :- |
| out_user_id | string | true | user id for fund out |
| in_user_id | string | true | user id for fund in |
| amount | float | true | amount of fund |

- Response

| Field | Type | Description |
| :- | :- | :- |
| code | int |
| transaction_id | bigint |
| balance | float | balance for fund out user |

```json
// success
{
  "code": 0,
  "transaction_id": 1,
  "balance": 0.00
}

// not enough fund
{
  "code": 1,
  "balance": 90.00
}
```
