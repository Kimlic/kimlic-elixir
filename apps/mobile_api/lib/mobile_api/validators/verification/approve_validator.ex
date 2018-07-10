defmodule MobileApi.Validators.Verification.ApproveValidator do
  use Ecto.Schema

  import Ecto.Changeset

  @required ~w(code)a

  @primary_key false
  embedded_schema do
    field(:code, :string)
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
