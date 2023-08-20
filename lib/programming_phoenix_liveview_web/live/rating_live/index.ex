defmodule ProgrammingPhoenixLiveviewWeb.RatingLive.Index do
  use Phoenix.Component
  use Phoenix.HTML
  alias ProgrammingPhoenixLiveviewWeb.RatingLive

  attr :products, :list, required: true
  attr :current_user, :any, required: true
  def product_list(assigns) do
    ~H"""
      <.heading products={@products} />
      <div class="grid grid-cols-2 gap-4 divide-y">
        <.product_rating
          :for={{p, i} <- Enum.with_index(@products)}
          current_user={@current_user}
          product={p}
          index={i}
        />
      </div>
    """
  end
end
