defmodule ProgrammingPhoenixLiveview.Promo.Recipient do
  defstruct [:first_name, :email]
  @types %{first_name: :string, email: :string}
  import Ecto.Changeset

  # __MODULE__ is a macro that returns the current module name as an atom
  def changeset(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
