defmodule MobileApi.FallbackController do
  @moduledoc """
  This controller should be used as `action_fallback` in rest of controllers to remove duplicated error handling.
  """

  use MobileApi, :controller

  alias MobileApi.ErrorView

  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, :"404")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ErrorView, :"404")
  end

  def call(conn, {:error, {:"422", error}}) do
    conn
    |> put_status(422)
    |> render(ErrorView, :"422", %{message: error})
  end

  def call(conn, %Ecto.Changeset{valid?: false} = changeset) do
    call(conn, {:error, changeset})
  end

  def call(conn, {:error, %Ecto.Changeset{valid?: false} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ErrorView, :"422", changeset)
  end

  def call(conn, {:error, {:internal_error, message}}) do
    conn
    |> put_status(:internal_server_error)
    |> render(ErrorView, :"500", %{message: message})
  end
end
