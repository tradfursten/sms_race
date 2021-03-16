defmodule Smsrace.Repo.Migrations.CreateCheckpoints do
  use Ecto.Migration

  def change do
    create table(:checkpoints) do
      add :name, :string
      add :distance, :float
      add :cutoff, :utc_datetime
      add :code, :string
      add :race_id, references(:races, on_delete: :nothing)

      timestamps()
    end

    create index(:checkpoints, [:race_id])
  end
end
