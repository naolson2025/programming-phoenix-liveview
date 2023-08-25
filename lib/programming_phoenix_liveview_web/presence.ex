defmodule ProgrammingPhoenixLiveviewWeb.Presence do
  use Phoenix.Presence, otp_app: :programming_phoenix_liveview,
  pubsub_server: ProgrammingPhoenixLiveview.PubSub
end
