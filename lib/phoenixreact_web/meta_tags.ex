defmodule PhoenixreactWeb.MetaTags do
  import Plug.Conn

  def set_meta_tag_values(conn, _opts) do
    current_url = PhoenixreactWeb.Endpoint.url() <> conn.request_path
    og_image_url = PhoenixreactWeb.Endpoint.url() <> "/og.png"

    # Note that when navigating via an Inertia Link, the meta tag url values will not change, recommend using <a> tags instead of <Link> if these have to be changed
    conn
    |> assign(:current_url, current_url)
    |> assign(:og_image_url, og_image_url)
  end
end
