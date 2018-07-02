# Environment Variables

This environment variables can be used to configure released docker container at start time.
Also sample `.env` can be used as payload for `docker run` cli.

# Endpoints

## API Endpoints (Attestation / Mobile / Public / Proxy)

| VAR_NAME   | Default Value    | Description                         |
| ---------- | ---------------- | ----------------------------------- |
| HOST       | `80`             | HTTP host for web app to listen on. |
| PORT       | `localhost`      | HTTP port for web app to listen on. |
| SECRET_KEY | `b9WHCgR5TGcr`.. | Phoenix [`:secret_key_base`].       |

# Infrastructure

## Database

| VAR_NAME      | Default Value | Description   |
| ------------- | ------------- | ------------- |
| POSTGRES_URI  | not set       | Postgres URI. |

## Redis

| VAR_NAME      | Default Value | Description   |
| ------------- | ------------- | ------------- |
| REDIS_URI     | not set       | Redis URI.    |

## RabbitMQ

| VAR_NAME          | Default Value | Description        |
| ----------------- | ------------- | ------------------ |
| RABBITMQ_HOST     | not set       | RabbitMQ host.     |
| RABBITMQ_USERNAME | not set       | RabbitMQ username. |
| RABBITMQ_PASSWORD | not set       | RabbitMQ password. |

## Quorum

| VAR_NAME                   | Default Value | Description                        |
| -------------------------- | ------------- | ---------------------------------- |
| AUTHORIZATION_SALT         | not set       | Authorization salt.                |
| QUORUM_URI                 | not set       | Quorum uri for ethereumex.         |
| KIMLIC_AP_ADDRESS          | not set       | Kimlic attestation party address.  |
| KIMLIC_AP_PASSWORD         | not set       | Kimlic attestation party password. |
| CONTEXT_STORAGE_ADDRESS    | not set       | Context storage address.           |
| QUORUM_ALLOWED_RPC_METHODS | [`web3_clientVersion`, `eth_call`, `eth_sendTransaction`, `eth_sendRawTransaction`, `eth_getTransactionCount`] | Quorum allowed rpc methods. |

# 3rd party

## Twilio

| VAR_NAME           | Default Value | Description         |
| ------------------ | ------------- | ------------------- |
| TWILIO_ACCOUNT_SID | not set       | Account secret id.  |
| TWILIO_AUTH_TOKEN  | not set       | Account auth token. |

## Amazon SES

| VAR_NAME                   | Default Value | Description                      |
| -------------------------- | ------------- | -------------------------------- |
| AMAZON_SES_REGION_ENDPOINT | not set       | Region endpoint. Ex: `eu-west-1` |
| AMAZON_SES_ACCESS_KEY      | not set       | Access key.                      |
| AMAZON_SES_SECRET_KEY      | not set       | Access secret.                   |

## Veriffme

| VAR_NAME              | Default Value | Description  |
| --------------------- | ------------- | ------------ |
| VERIFFME_API_URL      | not set       | Api url.     |
| VERIFFME_AUTH_CLIENT  | not set       | Auth client. |
| VERIFFME_API_SECRET   | not set       | Auth secret. |

# Business

## TTL 

| VAR_NAME               | Default Value | Description                                       |
| ---------------------- | ------------- | ------------------------------------------------- |
| VERIFICATION_EMAIL_TTL | `86400`       | Time to live for email verification (in seconds). |
| VERIFICATION_PHONE_TTL | `86400`       | Time to live for phone verification (in seconds). |

## SMS

| VAR_NAME               | Default Value | Description  |
| ---------------------- | ------------- | ------------ |
| MESSENGER_MESSAGE_FROM | `Kimlic`      | Sender name. |

## Emails

| VAR_NAME                        | Default Value                          | Description                       |
| ------------------------------- | -------------------------------------- | --------------------------------- |
| EMAIL_CREATE_PROFILE_FROM_EMAIL | `verification@kimlic.com`              | Sender email on create profile.   |
| EMAIL_CREATE_PROFILE_FROM_NAME  | `Kimlic`                               | Sender name on create profile.    |
| EMAIL_CREATE_PROFILE_SUBJECT    | `Kimlic - New user email verification` | Sender subject on create profile. |

## Rate limits 

| VAR_NAME                                      | Default Value          | Description                             |
| --------------------------------------------- | ---------------------- | --------------------------------------- |
| RATE_LIMIT_CREATE_PHONE_VERIFICATION_TIMEOUT  | `604800000` week in ms | Timeout for phone verification (in ms). |
| RATE_LIMIT_CREATE_PHONE_VERIFICATION_ATTEMPTS | `5`                    | Max attempts for phone verification.    |
