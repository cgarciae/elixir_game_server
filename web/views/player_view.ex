defmodule GameServer.PlayerView do
  use GameServer.Web, :view

  def render("index.json", %{players: players}) do
    render_many(players, GameServer.PlayerView, "show.json")
  end

  def render("show.json", %{player: player}) do
    %{id: player.id,
      initial_money: player.initial_money,
      final_money: player.final_money,
      game_id: player.game_id}
  end
end
