defmodule PhoenixreactWeb.AdminController do
  use PhoenixreactWeb, :controller

  def dashboard(conn, _params) do
    conn
    |> PhoenixreactWeb.PageTitle.assign("Dashboard")
    |> render_inertia("admin/dashboard")
  end
end
