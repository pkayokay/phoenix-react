defmodule PhoenixreactWeb.Plugs.SetMetaUrl do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_url = PhoenixreactWeb.Endpoint.url() <> conn.request_path
    og_image_url = PhoenixreactWeb.Endpoint.url() <> "/og.png"

    # Note that when navigating via an Inertia Link, the meta tag url values will not change, recommend using <a> tags instead of <Link> if these have to be changed
    conn
    |> assign(:current_url, current_url)
    |> assign(:og_image_url, og_image_url)
  end
end
