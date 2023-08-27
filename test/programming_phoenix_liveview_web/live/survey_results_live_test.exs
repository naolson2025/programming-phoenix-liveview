defmodule ProgrammingPhoenixLiveviewWeb.SurveyResultsLiveTest do
  use ProgrammingPhoenixLiveviewWeb.ConnCase
  use ProgrammingPhoenixLiveviewWeb.DataCase
  alias ProgrammingPhoenixLiveviewWeb.Admin.SurveyResultsLive
  alias ProgrammingPhoenixLiveview.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    description: "Product 1 description",
    name: "Product 1",
    sku: 42,
    unit_price: 100
  }

  @create_user_attrs %{
    email: "test@test.com",
    password: "passwordpassword"
  }

  @create_user2_attrs %{
    email: "test2@test.com",
    password: "passwordpassword"
  }

  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: 1990
  }

  @create_demographic2_attrs %{
    gender: "male",
    year_of_birth: 1985
  }

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs \\ @create_demographic_attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})
    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(stars, user, product) do
    {:ok, rating} = Survey.create_rating(%{stars: stars, user_id: user.id, product_id: product.id})
    rating
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_rating(stars, user, product) do
    rating = rating_fixture(stars, user, product)
    %{rating: rating}
  end

  defp create_demographic(user) do
    demographic = demographic_fixture(user)
    %{demographic: demographic}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end
end
