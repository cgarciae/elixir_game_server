defmodule GameServer.GameControllerTest do
  use GameServer.ConnCase

  alias GameServer.Game
  @valid_attrs %{n_iterations: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, game_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    game = Repo.insert! %Game{}
    conn = get conn, game_path(conn, :show, game)
    assert json_response(conn, 200) == %{"id" => game.id,
      "n_iterations" => game.n_iterations, "players" => [], "test" => nil}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, game_path(conn, :show, -1)
    end
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    # conn = post conn, game_path(conn, :create), game: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    game = Repo.insert! %Game{}
    conn = put conn, game_path(conn, :update, game), game: @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Game, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    #game = Repo.insert! %Game{}
    #conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
    #assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    game = Repo.insert! %Game{}
    conn = delete conn, game_path(conn, :delete, game)
    assert response(conn, 204)
    refute Repo.get(Game, game.id)
  end
end
