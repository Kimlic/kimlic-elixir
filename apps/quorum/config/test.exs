use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :ex_unit, capture_log: true

config :quorum,
  authorization_salt: "1234567890",
  kimlic_ap_address: "0x0b5d5e3403128e29b3b55a1c8b518b17dcc0fb3a",
  kimlic_ap_password: "Kimlicp@ssw0rd",
  veriff_ap_address: "0xe414ba511451ebbfc91de224ede2dea4c51d3d07",
  veriff_ap_password: "Veriffp@ssw0rd",
  context_storage_address: "0xf928fd62717792c14e661749bfa74821a563d1b4",
  #  client: QuorumClientMock,
  client: Ethereumex.HttpClient,
  proxy_client: QuorumClientProxyMock

config :ethereumex, url: "http://40.115.43.126:22000"

# for test purposes only
config :quorum,
  relying_party_address: "0xca94eff4ebed3b1d15c89a77acf9fb87ce64ec77",
  relying_party_password: "FirstRelyingPartyp@ssw0rd"

config :task_bunny,
  queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "transaction", jobs: [TransactionCreate]],
      [name: "transaction-status", jobs: [TransactionStatus]]
    ]
  ]
