defmodule Icebreaker.Repo do
  use Ecto.Repo,
    otp_app: :icebreaker,
    adapter: Ecto.Adapters.Postgres
end
