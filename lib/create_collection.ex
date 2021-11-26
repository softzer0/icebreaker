defmodule Icebreaker.CreateCollection do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [name: __MODULE__])
  end

  def init(_) do
    IO.inspect(ExAws.Rekognition.create_collection("icebreaker") |> ExAws.request())
    {:ok, nil}
  end
end
