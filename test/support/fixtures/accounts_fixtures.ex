defmodule Icebreaker.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Icebreaker.Accounts` context.
  """

  @doc """
  Generate a unique person phone.
  """
  def unique_person_phone, do: "some phone#{System.unique_integer([:positive])}"

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        birthdate: ~N[2021-10-28 23:01:00],
        name: "some name",
        phone: unique_person_phone()
      })
      |> Icebreaker.Accounts.create_person()

    person
  end
end
