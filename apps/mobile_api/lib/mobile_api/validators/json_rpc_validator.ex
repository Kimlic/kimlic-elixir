defmodule MobileApi.JSONRPCValidator do
  import Ecto.Changeset

  defmodule Request do
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:id, :integer)
      field(:method, :string)
    end
  end

  defmodule RequestBatch do
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      embeds_many(:_json, Request)
    end
  end

  @required ~w(id method)a

  @spec changeset(map) :: Changeset.t()
  def changeset(%{"_json" => _} = attrs) do
    %RequestBatch{}
    |> cast(attrs, [])
    |> cast_embed(:_json, with: &changeset/2)
  end

  @spec changeset(map) :: Changeset.t()
  def changeset(attrs), do: changeset(%Request{}, attrs)

  @spec changeset(struct, map) :: Changeset.t()
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
