import Ecto.Query
alias ProgrammingPhoenixLiveview.Accounts.User
alias ProgrammingPhoenixLiveview.Catalog.Product
alias ProgrammingPhoenixLiveview.{Repo, Accounts, Survey}

for i <- 1..43 do
  Accounts.register_user(%{
    username: "user#{i}_username",
    email: "user#{i}@example.com",
    password: "passwordpassword"
  }) |> IO.inspect
end

user_ids = Repo.all(from u in User, select: u.id)
product_ids = Repo.all(from p in Product, select: p.id)
genders = ["female", "male"]
years = 1960..2017
stars = 1..5

for uid <- user_ids do
  Survey.create_demographic(%{
    user_id: uid,
    gender: Enum.random(genders),
    year_of_birth: Enum.random(years)
  })
end

for uid <- user_ids, pid <- product_ids do
  Survey.create_rating(%{
    user_id: uid,
    product_id: pid,
    stars: Enum.random(stars)
  })
end
