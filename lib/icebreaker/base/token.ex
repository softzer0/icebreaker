defmodule Icebreaker.Base.Token do
  def generate() do
    :crypto.strong_rand_bytes(4) |> Base.encode32(padding: false)
  end
end
