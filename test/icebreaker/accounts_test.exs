defmodule Icebreaker.AccountsTest do
  use Icebreaker.DataCase

  alias Icebreaker.Accounts

  describe "persons" do
    alias Icebreaker.Accounts.Person

    import Icebreaker.AccountsFixtures

    @invalid_attrs %{birthdate: nil, name: nil, phone: nil}

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Accounts.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Accounts.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{birthdate: ~N[2021-10-28 23:01:00], name: "some name", phone: "some phone"}

      assert {:ok, %Person{} = person} = Accounts.create_person(valid_attrs)
      assert person.birthdate == ~N[2021-10-28 23:01:00]
      assert person.name == "some name"
      assert person.phone == "some phone"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      update_attrs = %{birthdate: ~N[2021-10-29 23:01:00], name: "some updated name", phone: "some updated phone"}

      assert {:ok, %Person{} = person} = Accounts.update_person(person, update_attrs)
      assert person.birthdate == ~N[2021-10-29 23:01:00]
      assert person.name == "some updated name"
      assert person.phone == "some updated phone"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_person(person, @invalid_attrs)
      assert person == Accounts.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Accounts.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Accounts.change_person(person)
    end
  end
end
