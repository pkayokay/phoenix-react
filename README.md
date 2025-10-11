# Phoenix React Boilerplate

## Fork
- Replace `Phoenixreact` with your project's name
- Replace `phoenixreact` with your project's name lowercased.
- Rename `phoenixreact_...` directories with your project's name lowercased.

## Install npm dependencies

- `mix install`

## React

- `mix lint` to lint via eslint with prettier rules.
- `mix ts` for type checking.

## Server side rendering

To server render a component, pass in a prop of `ssr` set to true.

```ex
  def home(conn, _params) do
    conn
    ...
    |> assign_prop(:ssr, true)
    |> render_inertia("some-component", ssr: true)
  end
```

## Set page title

Assigns server side page_title and passes a prop to set the same value on the client.

```ex
  def home(conn, _params) do
    conn
    ...
    |> PhoenixreactWeb.PageTitle.assign("Home Page - My App")
    ...
  end
```

---

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
