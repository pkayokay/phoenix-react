defmodule PhoenixreactWeb.PageController do
  use PhoenixreactWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
