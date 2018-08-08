defmodule MobileApi.Validators.Verification.PhoneValidator do
  use Ecto.Schema

  import Ecto.Changeset

  alias EView.Changeset.Validators.PhoneNumber

  @required ~w(phone)a

  @primary_key false
  embedded_schema do
    field(:phone, :string)
  end

  @spec changeset(map) :: Changeset.t()
  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> PhoneNumber.validate_phone_number(:phone)
  end
end
