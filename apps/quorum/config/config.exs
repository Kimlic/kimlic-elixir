use Mix.Config

alias Quorum.Jobs.{
  CreateUserAccount,
  CreateVerificationContract,
  TransactionCreate,
  TransactionStatus,
  UpdateUserAccount
}

config :quorum, client: Ethereumex.HttpClient

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
  ]

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
