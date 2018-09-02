defmodule ScorifyElixir.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  @doc false
  def changeset(%ScorifyElixir.Auth.User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> validate_length(:name, min: 3, max: 50)
    |> validate_length(:password, min: 8, max: 255)
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, pass |> Comeonin.Bcrypt.hashpwsalt())

      _ ->
        changeset
    end
  end
end
