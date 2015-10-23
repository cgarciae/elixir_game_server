defmodule GameServer.GameView do
  use GameServer.Web, :view

  alias GameServer.PlayerView
  alias Ecto.Association.NotLoaded

  @attributes ~W(id n_iterations players)a

  def render("index.json", %{games: games}) do
    render_many(games, GameServer.GameView, "show.json")
  end

  def render("show.json", %{game: game}) do
    json = %{
      id: game.id,
      n_iterations: game.n_iterations,
      test: game.test}

    if not match?(%NotLoaded{}, game.players) do
      players_json = Enum.map(game.players, &PlayerView.render("show.json", %{player: &1}))
      Map.put(json, :players, players_json)
    else
      json
    end
  end
end
