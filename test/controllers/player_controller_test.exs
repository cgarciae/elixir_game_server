defmodule GameServer.PlayerControllerTest do
  use GameServer.ConnCase

  alias GameServer.Player
  @valid_attrs %{final_money: 42, initial_money: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() 
      |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, player_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "shows chosen resource", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = get conn, player_path(conn, :show, player)
    assert json_response(conn, 200) == %{"id" => player.id,
      "initial_money" => player.initial_money,
      "final_money" => player.final_money,
      "game_id" => player.game_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, player_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, player_path(conn, :create), player: @valid_attrs
    assert json_response(conn, 201)["id"]
    assert Repo.get_by(Player, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    # conn = post conn, player_path(conn, :create), player: @invalid_attrs
    # assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = put conn, player_path(conn, :update, player), player: @valid_attrs
    assert json_response(conn, 200)["id"]
    assert Repo.get_by(Player, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    #player = Repo.insert! %Player{}
    #conn = put conn, player_path(conn, :update, player), player: @invalid_attrs
    #assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = delete conn, player_path(conn, :delete, player)
    assert response(conn, 204)
    refute Repo.get(Player, player.id)
  end
end
