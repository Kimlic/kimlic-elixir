use Mix.Config

alias Core.Jobs.{CreateUserAccount, CreateVerificationContract}
alias Quorum.Jobs.{UpdateUserAccount}

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://localhost?heartbeat=30"
    ]
  ],
  queue: [
    namespace: "kimlic-core.",
    queues: [
      [name: "create-user-account", jobs: [CreateUserAccount]],
      [name: "create-verification-contract", jobs: [CreateVerificationContract]],
      [name: "update-user-account", jobs: [UpdateUserAccount]]
    ]
  ]

config :logger, :console,
  format: "$message\n",
  handle_otp_reports: true,
  level: :info

import_config "#{Mix.env()}.exs"
