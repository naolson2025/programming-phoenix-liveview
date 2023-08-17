defmodule ProgrammingPhoenixLiveviewWeb.DemographicLive.Show do
  use Phoenix.Component
  use Phoenix.HTML
  alias ProgrammingPhoenixLiveview.Survey.Demographic
  alias ProgrammingPhoenixLiveviewWeb.CoreComponents

  # &#x2713; this is unicode that will be rendered as a checkmark
  attr :demographic, Demographic, required: true
  def details(assigns) do
    ~H"""
    <div>
      <h2 class="font-medium text-2xl">
        Demographics <%= raw "&#x2713;" %>
      </h2>
      <CoreComponents.table id="demographics" rows={[@demographic]}>
        <:col label="Gender">
          <%= @demographic.gender %>
        </:col>
        <:col label="Year of birth">
          <%= @demographic.year_of_birth %>
        </:col>
      </CoreComponents.table>
    </div>
    """
  end
end
