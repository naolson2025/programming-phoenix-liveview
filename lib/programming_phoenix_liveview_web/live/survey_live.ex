defmodule ProgrammingPhoenixLiveviewWeb.SurveyLive do
  alias ProgrammingPhoenixLiveview.Survey
  use ProgrammingPhoenixLiveviewWeb, :live_view
  alias __MODULE__.Component
  alias ProgrammingPhoenixLiveviewWeb.DemographicLive

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_demographic}
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end

  # we listen for a message from the child live view
  # form.ex will send the :created_demographic message
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic information saved")
    |> assign(:demographic, demographic)
  end
end
