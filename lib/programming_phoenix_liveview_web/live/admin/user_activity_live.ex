defmodule ProgrammingPhoenixLiveviewWeb.Admin.UserActivityLive do
  use ProgrammingPhoenixLiveviewWeb, :live_component
  alias ProgrammingPhoenixLiveviewWeb.Presence

  def update(_assigns, socket) do
    {
      :ok,
      socket
      |> assign_user_activity()
    }
  end

  def assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
