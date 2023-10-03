defmodule ProgrammingPhoenixLiveviewWeb.WrongLive do
  use ProgrammingPhoenixLiveviewWeb, :live_view

  # session is for securing this live view
  # mount returns a tuple with either: :ok or :error and a socket
  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket, # a socket is a map (key-value pairs)
        score: 0, # add another key-value pair
        message: "make a guess", # add another key-value pair
        winning_number: :rand.uniform(10),
        session_id: session["live_socket_id"],
        victory: false
      )
    }
  end

  # after mount, the render function is called automatically
  # and given the tuple {:ok, socket} from mount
  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <%!-- access state variables with @ --%>
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      <%!-- because the time variable is not added to the socket --%>
      <%!-- it will not update --%>
      <%!-- It's <%= time() %> --%>
    </h2>
    <br/>
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          href="#"
          phx-click="guess"
          phx-value-n={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <pre class="mt-4">
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    <%!-- if victory is true show a restart button --%>
    <%= if @victory do %>
      <.link
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border border-blue-700 rounded m-1 p-4"
        href="#"
        phx-click="restart"
      >
        Restart
      </.link>
    <% end %>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  # "guess" is the name of the event
  # the second argument is metadata from the event
  # we pattern match "n" to get the value the user clicked on
  # this is triggered by the phx-click event in the template
  def handle_event("guess", %{"n" => guess}, socket) do
    IO.inspect(guess)
    IO.inspect(socket.assigns.winning_number)
    # convert guess to integer
    guess = String.to_integer(guess)
    # check if the guessed number equals the winning_number
    if guess == socket.assigns.winning_number do
      # if it does, increment the score
      message = "Your guess: #{guess} is correct!"
      score = socket.assigns.score + 1
      {:noreply, assign(socket, score: score, message: message, victory: true)}
    else
      # if it doesn't, decrement the score
      message = "Your guess: #{guess}. Wrong, Guess again!"
      score = socket.assigns.score - 1
      {:noreply, assign(socket, score: score, message: message)}
    end
  end

  def handle_event("restart", _metadata, socket) do
    {:noreply, assign(socket, score: 0, message: "make a guess", victory: false, winning_number: :rand.uniform(10))}
  end
end
