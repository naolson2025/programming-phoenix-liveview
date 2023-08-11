# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ProgrammingPhoenixLiveview.Repo.insert!(%ProgrammingPhoenixLiveview.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias ProgrammingPhoenixLiveview.Catalog

products = [
  %{
    name: "Programming Phoenix 1.4",
    description: "The best book ever!",
    sku: 5316_3545,
    unit_price: 39.95
  },
  %{
    name: "Programming Elixir 1.6",
    description: "The second best book ever!",
    sku: 6316_3546,
    unit_price: 49.95
  },
  %{
    name: "Programming Ecto",
    description: "The third best book ever!",
    sku: 7316_3547,
    unit_price: 59.95
  }
]

Enum.each(products, fn product ->
  Catalog.create_product(product)
end)
