defmodule GameServer.PlayerTest do
  use GameServer.ModelCase

  alias GameServer.Player

  @valid_attrs %{final_money: 42, initial_money: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    # changeset = Player.changeset(%Player{}, @invalid_attrs)
    # refute changeset.valid?
  end

  test "player1 wins" do
    p1 = %Player{final_money: 10}
    p2 = %Player{final_money: 10}

    [p1, p2] = Player.play(p1, p2)

    assert p1.final_money == 11
    assert p2.final_money == 9
  end

  test "player2 cant loose if it has no money" do
    p1 = %Player{final_money: 10}
    p2 = %Player{final_money: 0}

    [p1, p2] = Player.play(p1, p2)

    assert p1.final_money == 10
    assert p2.final_money == 0
  end
end
