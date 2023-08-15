defmodule ProgrammingPhoenixLiveview.Survey.Rating.Query do
  import Ecto.Query
  alias ProgrammingPhoenixLiveview.Survey.Rating

  def base, do: Rating

  def preload_user(user) do
    base()
    |> for_user(user)
  end

  defp for_user(query, user) do
    query
    |> where([r], r.user_id == ^user.id)
  end
end
