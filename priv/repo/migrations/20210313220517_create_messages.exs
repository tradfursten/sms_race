defmodule Smsrace.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :api_id, :string
      add :from, :string
      add :to, :string
      add :message, :string
      add :direction, :string
      add :created, :utc_datetime
      add :deleted, :utc_datetime, default: nil

      add :handled, :boolean, default: false


      timestamps()
    end

  end
end
