defmodule GameServer.PlayerServices do
  use GameServer.Web, :controller

  alias GameServer.Player

  def insert!(player) do
    player = Map.delete(player, :__struct__)
    Player.changeset(%Player{}, player)
      |> Repo.insert!
  end
end