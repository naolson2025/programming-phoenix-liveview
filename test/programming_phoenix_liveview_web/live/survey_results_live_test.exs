defmodule ProgrammingPhoenixLiveviewWeb.SurveyResultsLiveTest do
  # use ExUnit.Case
  use ProgrammingPhoenixLiveviewWeb.ConnCase
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
    {:ok, rating} =
      Survey.create_rating(%{stars: stars, user_id: user.id, product_id: product.id})

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

  # The describe block groups a set of tests
  # before each test in the desc block is run it will run the setup block
  # @moduletag :test
  describe "Socket state" do
    setup [:create_user, :create_product, :create_socket, :register_and_log_in_user]

    setup %{user: user} do
      create_demographic(user)
      user2 = user_fixture(@create_user2_attrs)
      demographic_fixture(user2, @create_demographic2_attrs)
      [user2: user2]
    end

    test "no ratings exist", %{socket: socket} do
      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter
        |> SurveyResultsLive.assign_products_with_average_ratings
      assert socket.assigns.products_with_average_ratings == [{"Product 1", 0}]
    end

    test "ratings exist", %{socket: socket, user: user, product: product} do
      create_rating(5, user, product)
      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter
        |> SurveyResultsLive.assign_products_with_average_ratings
      assert socket.assigns.products_with_average_ratings == [{"Product 1", 5}]
    end

    test "ratings are filtered by age group", %{socket: socket, user: user, product: product, user2: user2} do
      create_rating(2, user, product)
      create_rating(3, user2, product)

      socket
      |> SurveyResultsLive.assign_age_group_filter()
      |> assert_keys(:age_group_filter, "all")
      |> update_socket(:age_group_filter, "18 and under")
      |> SurveyResultsLive.assign_age_group_filter()
      |> assert_keys(:age_group_filter, "18 and under")
      |> SurveyResultsLive.assign_products_with_average_ratings()
      |> assert_keys(:products_with_average_ratings, [{"Product 1", 0}])
    end

    defp update_socket(socket, key, value) do
      %{socket | assigns: Map.merge(socket.assigns, Map.new([{key, value}]))}
    end

    defp assert_keys(socket, key, value) do
      assert socket.assigns[key] == value
      socket
    end
  end
end
