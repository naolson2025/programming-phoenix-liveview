defmodule ProgrammingPhoenixLiveviewWeb.RatingLive.Form do
  use ProgrammingPhoenixLiveviewWeb, :live_component
  alias ProgrammingPhoenixLiveview.Survey
  alias ProgrammingPhoenixLiveview.Survey.Rating

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_rating()
      |> assign_changeset()
    }
  end

  def assign_rating(%{assigns: %{current_user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  def assign_changeset(%{assigns: %{rating: rating}} = socket) do
    assign(socket, :changeset, Survey.change_rating(rating))
  end
end
