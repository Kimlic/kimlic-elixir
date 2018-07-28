use Mix.Config

config :quorum,
  client: Ethereumex.HttpClient,
  proxy_client: Quorum.Proxy.Client,
  context_storage_address: "",
  kimlic_ap_address: "",
  kimlic_ap_password: "kimlicp@ssw0rd",
  veriff_ap_address: "",
  veriff_ap_password: "veriffp@ssw0rd",
  user_address: "",
  relying_party_address: "",
  relying_party_password: "firstRelyingPartyp@ssw0rd"

config :quorum,
  contracts: [
    account_storage: Quorum.Contract.Generated.AccountStorage,
    account_storage_adapter: Quorum.Contract.Generated.AccountStorageAdapter,
    base_verification: Quorum.Contract.Generated.BaseVerification,
    kimlic_context_storage: Quorum.Contract.Generated.KimlicContextStorage,
    kimlic_contracts_context: Quorum.Contract.Generated.KimlicContractsContext,
    verification_contract_factory: Quorum.Contract.Generated.VerificationContractFactory
  ]

config :task_bunny,
  quorum_queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "transaction", jobs: [Quorum.Jobs.TransactionCreate]],
      [name: "transaction-status", jobs: [Quorum.Jobs.TransactionStatus]]
    ]
  ]
