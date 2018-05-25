use Mix.Config

config :quorum, Quorum.AMQP.Connection,
  host: {:system, "EXTERNAL_MQ_HOST", "localhost"},
  port: {:system, :integer, "EXTERNAL_MQ_PORT", 5672},
  username: {:system, "EXTERNAL_MQ_USER", "guest"},
  password: {:system, "EXTERNAL_MQ_PASSWORD", "guest"},
  virtual_host: {:system, "EXTERNAL_MQ_VHOST", "/"},
  connection_timeout: {:system, :integer, "EXTERNAL_MQ_TIMEOUT", 15_000}

# RabbitMQ Consumers
config :quorum, Quorum.AMQP.Transaction.Consumer,
  queue: [
    name: {:system, "TRANSACTION_IN_QUEUE_NAME", "Transaction.In"},
    error_name: {:system, "TRANSACTION_IN_ERROR_QUEUE_NAME", "Transaction.In.Errors"},
    durable: {:system, :boolean, "TRANSACTION_IN_QUEUE_DURABLE", false}
  ],
  qos: [
    prefetch_count: {:system, :integer, "TRANSACTION_IN_QUEUE_PREFETCH_COUNT", 100}
  ]

# RabbitMQ Producers
config :quorum, Quorum.AMQP.Transaction.Producer,
  idle: {:system, :boolean, "TRANSACTION_OUT_IDLE", false},
  queue: [
    name: {:system, "TRANSACTION_OUT_QUEUE_NAME", "Transaction.Out"},
    error_name: {:system, "TRANSACTION_OUT_ERROR_QUEUE_NAME", "Transaction.Out.Errors"},
    routing_key: {:system, "TRANSACTION_OUT_ROUTING_KEY", ""},
    durable: {:system, :boolean, "TRANSACTION_OUT_QUEUE_DURABLE", false}
  ],
  exchange: [
    name: {:system, "TRANSACTION_OUT_EXCHANGE_NAME", "Transaction.Out"},
    type: :direct,
    durable: {:system, :boolean, "TRANSACTION_OUT_QUEUE_DURABLE", false}
  ]
