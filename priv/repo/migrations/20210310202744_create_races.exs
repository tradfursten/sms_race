defmodule Smsrace.Repo.Migrations.CreateRaces do
  use Ecto.Migration

  def change do
    create table(:races) do
      add :name, :string
      add :start, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:races, [:user_id])
  end
end
