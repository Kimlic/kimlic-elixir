use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: "${RABBITMQ_URI}",
    ]
  ]
