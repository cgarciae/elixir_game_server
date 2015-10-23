defmodule GameServer.GameServices do
  use GameServer.Web, :controller

  alias GameServer.Player
  alias GameServer.Game

  def play(game, n_players, initial_money) do

    players = for i <- 1..n_players do
      Player.new(initial_money, game.id)
    end

    Enum.reduce 1..game.n_iterations, players, fn(_, players) ->
      players
      |> Enum.shuffle
      |> Enum.chunk(2)
      |> pmap(fn [p1, p2] -> Player.play(p1, p2) end)
      |> Enum.flat_map(&(&1))
    end
  end

  def insert!(game) do
    game = Map.delete(game, :__struct__)

    %Game{}
      |> Game.changeset(game)
      |> Repo.insert!
  end

  def pmap(collecion, f) do
    collecion
    |> Enum.map(&Task.async(fn -> f.(&1) end))
    |> Enum.map(&Task.await/1)
  end
end