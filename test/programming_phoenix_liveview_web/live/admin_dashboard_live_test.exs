defmodule ProgrammingPhoenixLiveviewWeb.AdminDashboardLiveTest do
  use ProgrammingPhoenixLiveviewWeb.ConnCase
  import Phoenix.LiveViewTest
  alias ProgrammingPhoenixLiveview.{Accounts, Catalog, Survey}

  @create_product_attrs %{
    description: "Product 1 description",
    name: "Product 1",
    sku: 42,
    unit_price: 100
  }

  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15
  }

  @create_demographic_over_18_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 30
  }

  @create_user_attrs %{
    email: "test@test.com",
    password: "passwordpassword"
  }
  @create_user2_attrs %{
    email: "test2@test.com",
    password: "passwordpassword"
  }
  @create_user3_attrs %{
    email: "test3@test.com",
    password: "passwordpassword"
  }

  defp product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  defp user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  defp demographic_fixture(user, attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  defp rating_fixture(user, product, stars) do
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

  defp create_demographic(user, attrs \\ @create_demographic_attrs) do
    demographic = demographic_fixture(user, attrs)
    %{demographic: demographic}
  end

  defp create_rating(user, product, stars) do
    rating = rating_fixture(user, product, stars)
    %{rating: rating}
  end

  describe "Survey Results" do
    setup [:register_and_log_in_user, :create_product, :create_user]

    setup %{user: user, product: product} do
      create_demographic(user)
      create_rating(user, product, 2)

      user2 = user_fixture(@create_user2_attrs)
      create_demographic(user2, @create_demographic_over_18_attrs)
      create_rating(user2, product, 3)
      :ok
    end

    test "it filters by age group", %{conn: conn} do
      # render the live view
      {:ok, view, _html} = live(conn, "/admin/dashboard")
      params = %{"age_group_filter" => "18 and under"}

      # html =
        view
        # |> open_browser() # will show html of rendered live view in browser
        |> element("#age-group-form") # select the element
        # simulate user interaction of clicking "18 and under"
        |> render_change(params) =~ "<title>2.00</title>"
    end

    # Example of testing pubsub messages
    test "it updates to display newly created ratings", %{conn: conn, product: product} do
      {:ok, view, html} = live(conn, "/admin/dashboard")
      assert html =~ "<title>2.50</title>"
      user3 = user_fixture(@create_user3_attrs)
      create_demographic(user3)
      create_rating(user3, product, 3)

      # send a message to the live view
      send(view.pid, %{event: "rating_created"})
      # wait for the live view to update
      :timer.sleep(2)
      assert render(view) =~ "<title>2.67</title>"
    end
  end
end
