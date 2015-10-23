defmodule GameServer.Repo.Migrations.Json do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :test, :json
    end
  end
end
