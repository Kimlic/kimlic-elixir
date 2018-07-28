use Mix.Config

alias Quorum.Jobs.{TransactionCreate, TransactionStatus}

config :ex_unit, capture_log: true

config :quorum,
  client: QuorumClientMock,
  proxy_client: QuorumClientProxyMock,
  context_storage_address: "",
  kimlic_ap_address: "",
  kimlic_ap_password: "Kimlicp@ssw0rd",
  veriff_ap_address: "",
  veriff_ap_password: "Veriffp@ssw0rd",
  user_address: ""

config :ethereumex, url: "http://localhost:22000"

config :quorum,
  contracts: [
    account_storage: AccountStorageMock,
    account_storage_adapter: AccountStorageAdapterMock,
    base_verification: BaseVerificationMock,
    kimlic_context_storage: KimlicContextStorageMock,
    kimlic_contracts_context: KimlicContractsContextMock,
    verification_contract_factory: VerificationContractFactoryMock
  ]

config :task_bunny,
  quorum_queue: [
    namespace: "kimlic-core-test.",
    queues: [
      [name: "transaction", jobs: [TransactionCreate], worker: false],
      [name: "transaction-status", jobs: [TransactionStatus], worker: false]
    ]
  ]

integration_tests? = Enum.join(System.argv(), " ") =~ "--only integration"
has_config_file? = File.exists?("#{__DIR__}/test_integration.priv.exs")

integration_tests? and has_config_file? and import_config "test_integration.priv.exs"
