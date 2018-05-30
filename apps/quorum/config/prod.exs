use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: "${RABBITMQ_URI}"
    ]
  ]

config :ethereumex, url: "${QUORUM_URI}"