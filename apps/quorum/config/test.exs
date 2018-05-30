use Mix.Config

alias Core.Jobs.{CreateUserAccount, CreateVerificationContract}
alias Quorum.Jobs.{UpdateUserAccount}

config :ex_unit, capture_log: true

config :quorum, client: QuorumClientMock

config :task_bunny,
  queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "create-user-account", jobs: [CreateUserAccount], worker: false],
      [name: "create-verification-contract", jobs: [CreateVerificationContract], worker: false],
      [name: "update-user-account", jobs: [UpdateUserAccount], worker: false]
    ]
  ]
