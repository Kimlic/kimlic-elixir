use Mix.Config

alias Core.Jobs.{CreateUserAccount, CreateVerificationContract}

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://localhost?heartbeat=30"
    ]
  ]

config :task_bunny,
  queue: [
    namespace: "kimlic-core.",
    queues: [
      [name: "create-user-account", jobs: [CreateUserAccount]],
      [name: "create-verification-contract", jobs: [CreateVerificationContract]]
    ]
  ]

import_config "#{Mix.env()}.exs"
