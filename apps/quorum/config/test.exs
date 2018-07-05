use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :ex_unit, capture_log: true

config :quorum,
  authorization_salt: "1234567890",
  kimlic_ap_address: "",
  kimlic_ap_password: "Kimlicp@ssw0rd",
  veriff_ap_address: "",
  veriff_ap_password: "Veriffp@ssw0rd",
  context_storage_address: "",
  client: QuorumClientMock,
  proxy_client: QuorumClientProxyMock

config :ethereumex, url: "http://localhost:22000"

# for test purposes only
config :quorum,
  relying_party_address: "",
  relying_party_password: "FirstRelyingPartyp@ssw0rd"

config :task_bunny,
  queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "transaction", jobs: [TransactionCreate], worker: false],
      [name: "transaction-status", jobs: [TransactionStatus], worker: false]
    ]
  ]
