defmodule Smsrace.Repo.Migrations.CreatePassages do
  use Ecto.Migration

  def change do
    create table(:passages) do
      add :at, :utc_datetime
      add :checkpoint_id, references(:checkpoints, on_delete: :nothing)
      add :participant_id, references(:participants, on_delete: :nothing)

      timestamps()
    end

    create index(:passages, [:checkpoint_id])
    create index(:passages, [:participant_id])
  end
end
