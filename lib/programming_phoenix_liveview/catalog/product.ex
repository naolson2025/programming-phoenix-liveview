defmodule ProgrammingPhoenixLiveview.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProgrammingPhoenixLiveview.Survey.Rating

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :image_upload, :string

    timestamps()
    has_many :ratings, Rating
  end

  def changeset(product, %{"unit_price" => _unit_price} = attrs) do
    current_price = get_in(product, [Access.key!(:unit_price)])

    product
    |> cast(attrs, [:unit_price])
    |> validate_number(:unit_price, less_than: current_price)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0)
  end
end
