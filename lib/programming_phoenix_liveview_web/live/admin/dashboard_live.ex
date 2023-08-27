defmodule ProgrammingPhoenixLiveviewWeb.Admin.DashboardLive do
  alias ProgrammingPhoenixLiveviewWeb.Admin.UserActivityLive
  alias ProgrammingPhoenixLiveviewWeb.Admin.SurveyResultsLive
  use ProgrammingPhoenixLiveviewWeb, :live_view
  # import these 2 for PubSub
  alias ProgrammingPhoenixLiveviewWeb.Endpoint
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"

  def mount(_params, _session, socket) do
    # subscribe to the survey_results topic
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
    end

    {
      :ok,
      socket
      # assign one key value pair to the socket
      |> assign(:survey_results_component_id, "survey-results")
      |> assign(:user_activity_component_id, "user-activity")
    }
  end

  def handle_info(%{event: "rating_created"}, socket) do
    # this will trigger the survey results live component to re-render
    # fetching the latest data from the database
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(UserActivityLive, id: socket.assigns.user_activity_component_id)
    {:noreply, socket}
  end
end
