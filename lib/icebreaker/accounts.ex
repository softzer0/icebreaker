defmodule Icebreaker.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  import Geo.PostGIS
  alias Icebreaker.Repo

  alias Icebreaker.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user_by_phone(phone), do: Repo.get_by(User, phone: phone)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Icebreaker.Accounts.Location

  # @doc """
  # Returns the list of locations.

  # ## Examples

  #     iex> list_locations()
  #     [%Location{}, ...]

  # """
  # def list_locations do
  #   Repo.all(Location)
  # end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)
  def get_location_by_user!(user_id), do: Repo.get_by!(Location, user_id: user_id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(user, attrs \\ %{}) do
    %Location{user: user}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  # @doc """
  # Deletes a location.

  # ## Examples

  #     iex> delete_location(location)
  #     {:ok, %Location{}}

  #     iex> delete_location(location)
  #     {:error, %Ecto.Changeset{}}

  # """
  # def delete_location(%Location{} = location) do
  #   Repo.delete(location)
  # end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  def save_session(%User{} = user, token) do
    Ecto.build_assoc(user, :sessions, %{token: token})
    |> Repo.insert()
  end

  def list_users_in_vicinity(user_id) do
    user_location = get_location_by_user!(user_id)
    query = from user in User, join: location in Location, on: location.user_id == user.id and user.id != ^user_id
    query = from [user, location] in query,
            select: %{
              id: user.id,
              name: user.name,
              last_selfie_id: user.last_selfie_id,
              age: fragment("EXTRACT(YEAR FROM AGE(CAST(? AS DATE)))::int", user.birthdate),
              last_active_ago: fragment("EXTRACT(EPOCH FROM (NOW() - ?))::int as last_active_ago", location.updated_at),
              distance: fragment("? as distance", st_distance_in_meters(location.coords, ^user_location.coords))
            },
            where: fragment("EXTRACT(EPOCH FROM (NOW() - ?))::int", location.updated_at) < 24 * 60 * 60, # and st_distance_in_meters(location.coords, ^user_location.coords)) < 500,
            order_by: [fragment("distance"), fragment("last_active_ago")]
    Repo.all(query)
  end
end
