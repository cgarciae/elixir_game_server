defmodule GameServer.GameTest do
  use GameServer.ModelCase

  alias GameServer.Game

  @valid_attrs %{n_iterations: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end


end
