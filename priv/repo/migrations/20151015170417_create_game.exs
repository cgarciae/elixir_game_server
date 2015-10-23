defmodule GameServer.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :n_iterations, :integer

      timestamps
    end

  end
end
