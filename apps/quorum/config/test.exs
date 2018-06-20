use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :ex_unit, capture_log: true

config :quorum,
  authorization_salt: "1234567890",
  kimlil_ap_password: "Kimlicp@ssw0rd",
  context_storage_address: "0x5f48a34e082242fcbec7ab06218599a89d014849",
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
