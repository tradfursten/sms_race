defmodule Smsrace.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :number, :string
      add :emergency, :string

      timestamps()
    end

    alter table(:races) do
      add :organization_id, references(:organizations, on_delete: :nothing), null: false
      remove :user_id
    end


    alter table(:users) do
      add :organization_id, references(:organizations, on_delete: :nothing)
    end

    create index(:races, :organization_id)
    create index(:users, :organization_id)
  end
end
