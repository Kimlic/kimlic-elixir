use Mix.Config

config :quorum,
  client: Ethereumex.HttpClient,
  proxy_client: Quorum.Proxy.Client,
  kimlic_ap_address: "",
  kimlic_ap_password: "kimlicp@ssw0rd",
  veriff_ap_address: "",
  veriff_ap_password: "veriffp@ssw0rd",
  context_storage_address: "",
  user_address: "",
  relying_party_address: "",
  relying_party_password: "firstRelyingPartyp@ssw0rd"

config :quorum,
  contracts: [
    account_storage: Quorum.Contracts.Generated.AccountStorage,
    account_storage_adapter: Quorum.Contracts.Generated.AccountStorageAdapter,
    base_verification: Quorum.Contracts.Generated.BaseVerification,
    kimlic_context_storage: Quorum.Contracts.Generated.KimlicContextStorage,
    kimlic_contracts_context: Quorum.Contracts.Generated.KimlicContractsContext,
    verification_contract_factory: Quorum.Contracts.Generated.VerificationContractFactory
  ]

config :task_bunny,
  queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "transaction", jobs: [Quorum.Jobs.TransactionCreate]],
      [name: "transaction-status", jobs: [Quorum.Jobs.TransactionStatus]]
    ]
  ]
