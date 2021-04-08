defmodule Smsrace.SMSRace.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :name, :string
    field :nr, :integer
    field :phonenumber, :string
    belongs_to :race, Smsrace.SMSRace.Race
    has_many :passages, Smsrace.SMSRace.Passage

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:nr, :name, :phonenumber, :race_id])
    |> validate_required([:nr, :name, :phonenumber])
  end
end
