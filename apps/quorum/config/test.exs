use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :ex_unit, capture_log: true

config :quorum,
  authorization_salt: {:system, "AUTHORIZATION_SALT", "1234567890"},
  client: QuorumClientMock,
  proxy_client: QuorumClientProxyMock

config :task_bunny,
  queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "transaction", jobs: [TransactionCreate], worker: false],
      [name: "transaction-status", jobs: [TransactionStatus], worker: false]
    ]
  ]
