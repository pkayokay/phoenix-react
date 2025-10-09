defmodule PhoenixreactWeb.UserRegistrationController do
  use PhoenixreactWeb, :controller

  alias Phoenixreact.Accounts

  def new(conn, _params) do
    conn
    |> PhoenixreactWeb.PageTitle.assign("Sign Up")
    |> render_inertia("auth/sign-up")
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/app/sign_in/#{&1}")
          )

        conn
        |> put_flash(
          :info,
          "An email was sent to #{user.email}, please access it to confirm your account."
        )
        |> redirect(to: ~p"/app/sign_in")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign_errors(changeset)
        |> redirect(to: ~p"/app/sign_up")
    end
  end
end
