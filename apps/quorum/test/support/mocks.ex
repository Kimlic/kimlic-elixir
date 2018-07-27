Mox.defmock(QuorumClientMock, for: Ethereumex.Client.Behaviour)
Mox.defmock(QuorumClientProxyMock, for: Quorum.Proxy.ClientBehaviour)

Mox.defmock(AccountStorageMock, for: Quorum.Contract.Generated.AccountStorageBehaviour)
Mox.defmock(AccountStorageAdapterMock, for: Quorum.Contract.Generated.AccountStorageAdapterBehaviour)
Mox.defmock(BaseVerificationMock, for: Quorum.Contract.Generated.BaseVerificationBehaviour)
Mox.defmock(KimlicContextStorageMock, for: Quorum.Contract.Generated.KimlicContextStorageBehaviour)
Mox.defmock(KimlicContractsContextMock, for: Quorum.Contract.Generated.KimlicContractsContextBehaviour)
Mox.defmock(VerificationContractFactoryMock, for: Quorum.Contract.Generated.VerificationContractFactoryBehaviour)
