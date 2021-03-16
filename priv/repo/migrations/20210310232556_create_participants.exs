defmodule Smsrace.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :nr, :integer
      add :name, :string
      add :phonenumber, :string
      add :race_id, references(:races, on_delete: :nothing)

      timestamps()
    end

    create index(:participants, [:race_id])
  end
end
