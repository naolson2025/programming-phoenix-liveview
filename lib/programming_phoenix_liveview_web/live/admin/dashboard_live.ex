defmodule ProgrammingPhoenixLiveviewWeb.Admin.DashboardLive do
  alias ProgrammingPhoenixLiveviewWeb.Admin.SurveyResultsLive
  use ProgrammingPhoenixLiveviewWeb, :live_view
  # import these 2 for PubSub
  alias ProgrammingPhoenixLiveviewWeb.Endpoint
  @survey_results_topic "survey_results"

  def mount(_params, _session, socket) do
    # subscribe to the survey_results topic
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
    end

    {
      :ok,
      socket
      # assign one key value pair to the socket
      |> assign(:survey_results_component_id, "survey-results")
    }
  end

  def handle_info(%{event: "rating_created"}, socket) do
    # this will trigger the survey results live component to re-render
    # fetching the latest data from the database
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end
end
