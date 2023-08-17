defmodule ProgrammingPhoenixLiveviewWeb.DemographicLive.Form do
  use ProgrammingPhoenixLiveviewWeb, :live_component
  alias ProgrammingPhoenixLiveview.Survey
  alias ProgrammingPhoenixLiveview.Survey.Demographic

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> assign_changeset()
    }
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end
end
