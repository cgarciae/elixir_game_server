defmodule GameServer.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :initial_money, :integer
      add :final_money, :integer
      add :game_id, references(:games)

      timestamps
    end
    create index(:players, [:game_id])

  end
end
