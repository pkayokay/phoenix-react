defmodule PhoenixreactWeb.CustomComponents do
  use Phoenix.Component

  @doc """
  Renders SEO and social media meta tags.

  ## Examples

      <.meta_tags
        page_title={@page_title}
        current_url={@current_url}
        og_image_url={@og_image_url}
        csrf_token={get_csrf_token()}
      />
  """
  attr :page_title, :string, required: true, doc: "the page title for SEO"
  attr :current_url, :string, required: true, doc: "the current page URL"
  attr :og_image_url, :string, required: true, doc: "the Open Graph image URL"
  attr :csrf_token, :string, required: true, doc: "the CSRF token"
  attr :description, :string, default: nil, doc: "the page description for SEO"

  def meta_tags(assigns) do
    ~H"""
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content={@csrf_token} />
    <meta :if={@description} name="description" content={@description} />

    <%!-- Open Graph / Facebook --%>
    <meta property="og:type" content="website" />
    <meta property="og:url" content={@current_url} />
    <meta property="og:title" content={@page_title} />
    <meta property="og:image" content={@og_image_url} />
    <meta :if={@description} property="og:description" content={@description} />

    <%!-- Twitter --%>
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content={@current_url} />
    <meta property="twitter:title" content={@page_title} />
    <meta property="twitter:image" content={@og_image_url} />
    <meta :if={@description} property="twitter:description" content={@description} />

    <%!-- Favicon, theme --%>
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
    """
  end
end
