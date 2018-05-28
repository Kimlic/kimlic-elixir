use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: [
        host: "${RABBITMQ_HOST}",
        port: "${RABBITMQ_PORT}"
      ]
    ]
  ]
