use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :quorum,
  authorization_salt: {:system, "AUTHORIZATION_SALT"},
  client: Ethereumex.HttpClient,
  proxy_client: Quorum.Proxy.Client,
  allowed_rpc_methods:
    {:system, :list, "QUORUM_ALLOWED_RPC_METHODS",
     [
       "web3_clientVersion",
       "eth_call",
       "eth_sendTransaction",
       "eth_sendRawTransaction",
       "eth_getTransactionCount"
     ]}

config :ethereumex, url: "http://localhost:22000"

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://localhost?heartbeat=30"
    ]
  ],
  queue: [
    namespace: "kimlic-core.",
    queues: [
      [name: "transaction", jobs: [TransactionCreate]],
      [name: "transaction-status", jobs: [TransactionStatus]]
    ]
  ],
  failure_backend: [Quorum.Loggers.TaskBunny]

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
