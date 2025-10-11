defmodule PhoenixreactWeb.UserSessionControllerTest do
  use PhoenixreactWeb.ConnCase, async: true

  import Phoenixreact.AccountsFixtures
  alias Phoenixreact.Accounts
  import Inertia.Testing

  setup do
    %{unconfirmed_user: unconfirmed_user_fixture(), user: user_fixture()}
  end

  describe "GET /app/sign_in" do
    test "renders login page", %{conn: conn} do
      conn = get(conn, ~p"/app/sign_in")
      assert inertia_component(conn) == "auth/sign-in"
    end

    test "renders login page with email filled in (sudo mode)", %{conn: conn, user: user} do
      html =
        conn
        |> log_in_user(user)
        |> get(~p"/app/sign_in")
        |> html_response(200)

      assert html =~ "Sign in"
      refute html =~ "Register"
    end

    test "renders login page (email + password)", %{conn: conn} do
      conn = get(conn, ~p"/app/sign_in?mode=password")
      assert inertia_component(conn) == "auth/sign-in"
    end
  end

  describe "GET /app/sign_in/:token" do
    test "renders confirmation page for unconfirmed user", %{conn: conn, unconfirmed_user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      conn = get(conn, ~p"/app/sign_in/#{token}")
      assert html_response(conn, 200) =~ "Confirm"
    end

    test "renders login page for confirmed user", %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_login_instructions(user, url)
        end)

      conn = get(conn, ~p"/app/sign_in/#{token}")
      assert inertia_component(conn) == "auth/confirm"
    end

    test "raises error for invalid token", %{conn: conn} do
      conn = get(conn, ~p"/app/sign_in/invalid-token")
      assert redirected_to(conn) == ~p"/app/sign_in"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "Magic link is invalid or it has expired."
    end
  end

  describe "POST /app/sign_in - email and password" do
    test "logs the user in", %{conn: conn, user: user} do
      user = set_password(user)

      conn =
        post(conn, ~p"/app/sign_in", %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/app"
      conn = get(conn, ~p"/app")
      assert inertia_component(conn) == "admin/dashboard"
    end

    test "logs the user in with remember me", %{conn: conn, user: user} do
      user = set_password(user)

      conn =
        post(conn, ~p"/app/sign_in", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_phoenixreact_web_user_remember_me"]
      assert redirected_to(conn) == ~p"/app"
    end

    test "logs the user in with return to", %{conn: conn, user: user} do
      user = set_password(user)

      conn =
        conn
        |> init_test_session(user_return_to: "/foo/bar")
        |> post(~p"/app/sign_in", %{
          "user" => %{
            "email" => user.email,
            "password" => valid_user_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Welcome back!"
    end

    test "emits error message with invalid credentials", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/app/sign_in?mode=password", %{
          "user" => %{"email" => user.email, "password" => "invalid_password"}
        })

      assert redirected_to(conn) == ~p"/app/sign_in"
      conn = get(conn, ~p"/app/sign_in")
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Invalid email or password"
    end
  end

  describe "POST /app/sign_in - magic link" do
    test "sends magic link email when user exists", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/app/sign_in", %{
          "user" => %{"email" => user.email}
        })

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "If your email is in our system"
      assert Phoenixreact.Repo.get_by!(Accounts.UserToken, user_id: user.id).context == "login"
    end

    test "logs the user in", %{conn: conn, user: user} do
      {token, _hashed_token} = generate_user_magic_link_token(user)

      conn =
        post(conn, ~p"/app/sign_in", %{
          "user" => %{"token" => token}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/app"
      conn = get(conn, ~p"/app")
      assert inertia_component(conn) == "admin/dashboard"
    end

    test "confirms unconfirmed user", %{conn: conn, unconfirmed_user: user} do
      {token, _hashed_token} = generate_user_magic_link_token(user)
      refute user.confirmed_at

      conn =
        post(conn, ~p"/app/sign_in", %{
          "user" => %{"token" => token},
          "_action" => "confirmed"
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/app"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "User confirmed successfully."

      assert Accounts.get_user!(user.id).confirmed_at
      conn = get(conn, ~p"/app")
      assert inertia_component(conn) == "admin/dashboard"
    end

    test "emits error message when magic link is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/app/sign_in", %{
          "user" => %{"token" => "invalid"}
        })

      assert redirected_to(conn) == ~p"/app/sign_in"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "The link is invalid or it has expired."
    end
  end

  describe "DELETE /app/log_out" do
    test "logs the user out", %{conn: conn, user: user} do
      conn = conn |> log_in_user(user) |> delete(~p"/app/log_out")
      assert redirected_to(conn) == ~p"/app/sign_in"
      refute get_session(conn, :user_token)
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the user is not logged in", %{conn: conn} do
      conn = delete(conn, ~p"/app/log_out")
      assert redirected_to(conn) == ~p"/app/sign_in"
      refute get_session(conn, :user_token)
    end
  end
end
