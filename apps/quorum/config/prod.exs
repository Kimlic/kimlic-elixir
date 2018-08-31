use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://kimlic:v2re3X7tMP@51.140.244.242:5672?heartbeat=30"
      # connect_options: [
        # host: "${RABBITMQ_HOST}",
        # username: "${RABBITMQ_USERNAME}",
        # password: "${RABBITMQ_PASSWORD}"
      # ]
    ]
  ]

# config :ethereumex, url: "${QUORUM_URI}"
config :ethereumex, url: "http://51.141.123.209:22000"