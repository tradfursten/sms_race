defmodule Smsrace.SMSRace.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :name, :string
    field :nr, :integer
    field :phonenumber, :string
    field :race_id, :id

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:nr, :name, :phonenumber])
    |> validate_required([:nr, :name, :phonenumber])
  end
end
