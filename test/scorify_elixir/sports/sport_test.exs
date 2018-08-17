defmodule ScorifyElixir.Sports.SportTest do
  use ScorifyElixir.DataCase

  alias ScorifyElixir.Sports.Sport
  alias ScorifyElixir.Repo

  @valid_attrs %{name: "Tennis"}
  @valid_attrs_with_team %{name: "Basketball", team: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = %Sport{} |> Sport.changeset(@valid_attrs)
    assert changeset.valid?
  end

  test "changeset with specified :team attribute" do
    changeset = %Sport{} |> Sport.changeset(@valid_attrs_with_team)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = %Sport{} |> Sport.changeset(@invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with already existing name" do
    %Sport{} |> Sport.changeset(@valid_attrs) |> Repo.insert!
    assert {:error, _} = %Sport{} |> Sport.changeset(@valid_attrs) |> Repo.insert
  end
end
