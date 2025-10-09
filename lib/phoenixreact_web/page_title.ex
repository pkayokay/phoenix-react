defmodule PhoenixreactWeb.PageTitle do
  use PhoenixreactWeb, :controller

  def assign(conn, title) do
    conn
    |> assign(:page_title, title)
    |> assign_prop(:page_title, title)
  end
end
