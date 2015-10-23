defmodule GameServer.Game do
  use GameServer.Web, :model

  alias GameServer.Player
  alias GameServer.Game

  @type t :: %Game{
    n_iterations: integer,
    test: %{},
    players: Ecto.Association.NotLoaded.t | [Player.t]
  }

  schema "games" do
    field :n_iterations, :integer
    has_many :players, Player
    field :test, :map

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(n_iterations test)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
