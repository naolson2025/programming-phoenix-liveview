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
end
