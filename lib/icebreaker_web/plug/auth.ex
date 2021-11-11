defmodule IcebreakerWeb.Plug.Auth do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    # Phoenix.Token.sign(IcebreakerWeb.Endpoint, "test", user_id)
    IO.inspect(opts, label: "Auth Plug ~>")

    conn
    |> get_req_header("authorization")
    |> IO.inspect()

    conn
  end

  def sign_in(conn, user) do

  end
end
