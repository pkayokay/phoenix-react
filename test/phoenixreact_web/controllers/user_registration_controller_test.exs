defmodule PhoenixreactWeb.UserRegistrationControllerTest do
  use PhoenixreactWeb.ConnCase, async: true

  import Phoenixreact.AccountsFixtures
  import Inertia.Testing

  describe "GET /app/sign_up" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/app/sign_up")
      html_response(conn, 200)
      assert inertia_component(conn) == "auth/sign-up"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(~p"/app/sign_up")

      assert redirected_to(conn) == ~p"/app"
    end
  end

  describe "POST /app/sign_up" do
    @tag :capture_log
    test "creates account but does not log in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, ~p"/app/sign_up", %{
          "user" => valid_user_attributes(email: email)
        })

      refute get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/app/sign_in"

      assert conn.assigns.flash["info"] =~
               ~r/An email was sent to .*, please access it to confirm your account/
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/app/sign_up", %{
          "user" => %{"email" => "with spaces"}
        })

      assert redirected_to(conn) == ~p"/app/sign_up"
    end
  end
end
