defmodule ProgrammingPhoenixLiveviewWeb.WrongLive do
  use ProgrammingPhoenixLiveviewWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "make a guess")}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <%!-- access state variables with @ --%>
      <h1>Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
        <%!-- because the time variable is not added to the socket --%>
        <%!-- it will not update --%>
        It's <%= time() %>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-n={n}>
            <%= n %>
          </.link>
        <% end %>
      </h2>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  # "guess" is the name of the event
  # "n" is the name of the parameter
  def handle_event("guess", %{"n" => guess}, socket) do
    message = "Your guess: #{guess}. Wrong, Guess again!"
    score = socket.assigns.score - 1
    {:noreply, assign(socket, score: score, message: message)}
  end
end
