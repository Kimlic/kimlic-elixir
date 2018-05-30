use Mix.Config

alias Quorum.Jobs.{
  CreateUserAccount,
  CreateVerificationContract,
  TransactionCreate,
  TransactionStatus,
  UpdateUserAccount
}

config :ex_unit, capture_log: true

config :quorum, client: QuorumClientMock

config :task_bunny,
  queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "create-user-account", jobs: [CreateUserAccount], worker: false],
      [name: "create-verification-contract", jobs: [CreateVerificationContract], worker: false],
      [name: "update-user-account", jobs: [UpdateUserAccount], worker: false],
      [name: "transaction", jobs: [TransactionCreate], worker: false],
      [name: "transaction-status", jobs: [TransactionStatus], worker: false]
    ]
  ]
