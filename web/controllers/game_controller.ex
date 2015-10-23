defmodule GameServer.GameController do
  use GameServer.Web, :controller

  alias GameServer.Game
  alias GameServer.Player
  alias GameServer.PlayerView
  alias GameServer.GameServices
  alias GameServer.PlayerServices

  plug :scrub_params, "game" when action in [:create, :update]

  def index(conn, _params) do
    games = Repo.all(Game)
    render(conn, "index.json", games: games)
  end

  def create(conn, %{"game" => %{
    "n_iterations" => n_iterations,
    "n_players" => n_players,
    "initial_money" => initial_money,
    "test" => test}} = game_params) do

    try do
      game = GameServices.insert!(%Game{n_iterations: n_iterations, test: test})

      players = GameServices.play(game, n_players, initial_money)
      Enum.map(players, &PlayerServices.insert!/1)
      
      conn
        |> put_status(:created)
        |> put_resp_header("location", game_path(conn, :show, game))
        |> render("show.json", game: game)
    catch
      e ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(GameServer.ChangesetView, "error.json")
    end
  end

  def show(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)
      |> Repo.preload([:players])

    IO.inspect(game)

    render(conn, "show.json", game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Repo.get!(Game, id)
    changeset = Game.changeset(game, game_params)

    case Repo.update(changeset) do
      {:ok, game} ->
        render(conn, "show.json", game: game)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(GameServer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game)

    send_resp(conn, :no_content, "")
  end

  def players(conn, %{"id" => id} = _params) do
    
    players = Repo.all(
      from p in Player, 
      where: p.game_id == ^id,
      order_by: [desc: p.final_money])

    render(conn, PlayerView, "index.json", players: players)
  end

  def top(conn, %{"id" => id}) do
    player = Repo.one(
      from p in Player, 
      where: p.game_id == ^id,
      order_by: [desc: p.final_money],
      limit: 1)

    render(conn, PlayerView, "show.json", player: player)
  end

  def plot(conn, %{"id" => id}) do
    players = Repo.all(
      from p in Player, 
      where: p.game_id == ^id,
      select: p.final_money)
    
    url = "http://www.wolframalpha.com/input/?i=histogram+" <> Enum.join(players, ",")

    json conn, %{url: url}
  end
end
