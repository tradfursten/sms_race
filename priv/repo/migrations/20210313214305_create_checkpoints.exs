defmodule Smsrace.Repo.Migrations.CreateCheckpoints do
  use Ecto.Migration

  def change do
    create table(:checkpoints) do
      add :name, :string
      add :distance, :float
      add :code, :string
      add :race_id, references(:races, on_delete: :nothing)
      add :type, :string
      add :info, :string


      timestamps()
    end

    create index(:checkpoints, [:race_id])
  end
end
