defmodule AttestationApi.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import AttestationApi.Router.Helpers
      import AttestationApi.Factory
      import AttestationApi.TestHelper

      # The default endpoint for testing
      @endpoint AttestationApi.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AttestationApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AttestationApi.Repo, {:shared, self()})
    end

    conn =
      Phoenix.ConnTest.build_conn()
      |> put_account_address(tags)
      |> put_authorization_headers(tags)

    {:ok, conn: conn}
  end

  @spec put_account_address(Conn.t(), map) :: Conn.t()
  def put_account_address(conn, %{account_address: true}) do
    account_address = AttestationApi.Factory.generate(:account_address)

    conn
    |> Plug.Conn.put_req_header("account-address", account_address)
    |> Plug.Conn.assign(:account_address, account_address)
  end

  def put_account_address(conn, _tags), do: conn

  @spec put_authorization_headers(Conn.t(), map) :: Conn.t()
  def put_authorization_headers(conn, %{authorized: true}) do
    auth_token = Ecto.UUID.generate()
    bearer_token = Quorum.BearerService.bearer(auth_token)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer: #{bearer_token}")
    |> Plug.Conn.put_req_header("auth-secret-token", auth_token)
  end

  def put_authorization_headers(conn, _tags), do: conn
end
