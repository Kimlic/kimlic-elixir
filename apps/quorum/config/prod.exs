use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: [
        host: "${RABBITMQ_HOST}",
        username: "${RABBITMQ_USERNAME}",
        password: "${RABBITMQ_PASSWORD}"
      ]
    ]
  ]

config :ethereumex, url: "${QUORUM_URI}"
