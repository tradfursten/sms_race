defmodule Smsrace.SMSRace.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :name, :string
    field :start, :utc_datetime
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :start])
    |> validate_required([:name, :start])
  end
end
