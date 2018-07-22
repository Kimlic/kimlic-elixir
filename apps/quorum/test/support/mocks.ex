Mox.defmock(QuorumClientMock, for: Ethereumex.Client.Behaviour)
Mox.defmock(QuorumClientProxyMock, for: Quorum.Proxy.ClientBehaviour)

Mox.defmock(AccountStorageMock, for: Quorum.Contracts.Generated.AccountStorageBehaviour)
Mox.defmock(AccountStorageAdapterMock, for: Quorum.Contracts.Generated.AccountStorageAdapterBehaviour)
Mox.defmock(BaseVerificationMock, for: Quorum.Contracts.Generated.BaseVerificationBehaviour)
Mox.defmock(KimlicContextStorageMock, for: Quorum.Contracts.Generated.KimlicContextStorageBehaviour)
Mox.defmock(KimlicContractsContextMock, for: Quorum.Contracts.Generated.KimlicContractsContextBehaviour)
Mox.defmock(VerificationContractFactoryMock, for: Quorum.Contracts.Generated.VerificationContractFactoryBehaviour)
