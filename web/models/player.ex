defmodule GameServer.Player do
  use GameServer.Web, :model

  alias GameServer.Player
  alias GameServer.Game


  schema "players" do
    field :initial_money, :integer
    field :final_money, :integer
    belongs_to :game, Game

    timestamps
  end

  @type t :: %Player{
    initial_money: integer,
    final_money: integer,
    game_id: integer,
    game: Game.t
  }

  @required_fields ~w()
  @optional_fields ~w(initial_money final_money game_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @spec new(integer) :: t
  @spec new(integer, integer) :: t
  def new(initial_money, game_id \\ nil) do
    %Player{
      initial_money: initial_money, 
      final_money: initial_money,
      game_id: game_id}
  end

  @doc """
   p1 always wins 
  """
  @spec play(t, t) :: [t]
  def play(p1, p2) do
    if p2.final_money > 0 do
      [%{p1 | final_money: p1.final_money + 1},
      %{ p2 | final_money: p2.final_money - 1}]
    else
      [p1, p2]
    end
  end
end