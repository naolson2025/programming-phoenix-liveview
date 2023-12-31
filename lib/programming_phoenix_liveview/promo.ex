defmodule ProgrammingPhoenixLiveview.Promo do
  alias ProgrammingPhoenixLiveview.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_promo(_recipient, _attrs) do
    # send email to promo recipient
    {:ok, %Recipient{}}
  end
end
