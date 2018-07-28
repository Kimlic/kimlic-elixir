use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :quorum,
  client: Ethereumex.HttpClient,
  proxy_client: Quorum.Proxy.Client,
  context_storage_address: {:system, "CONTEXT_STORAGE_ADDRESS"},
  kimlic_ap_address: {:system, "KIMLIC_AP_ADDRESS"},
  kimlic_ap_password: {:system, "KIMLIC_AP_PASSWORD"},
  veriff_ap_address: {:system, "VERIFF_AP_ADDRESS"},
  veriff_ap_password: {:system, "VERIFF_AP_PASSWORD"},

  # User address is used to access `AccountStorageAdapter.getFieldDetails`
  user_address: {:system, "USER_ADDRESS"},
  allowed_rpc_methods:
    {:system, :list, "QUORUM_ALLOWED_RPC_METHODS",
     [
       "web3_clientVersion",
       "eth_call",
       "eth_sendTransaction",
       "eth_sendRawTransaction",
       "eth_getTransactionCount"
     ]}

config :quorum,
  contracts: [
    account_storage: Quorum.Contract.Generated.AccountStorage,
    account_storage_adapter: Quorum.Contract.Generated.AccountStorageAdapter,
    base_verification: Quorum.Contract.Generated.BaseVerification,
    kimlic_context_storage: Quorum.Contract.Generated.KimlicContextStorage,
    kimlic_contracts_context: Quorum.Contract.Generated.KimlicContractsContext,
    verification_contract_factory: Quorum.Contract.Generated.VerificationContractFactory
  ]

config :ethereumex, url: "http://localhost:22000"

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://localhost?heartbeat=30"
    ]
  ],
  quorum_queue: [
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
