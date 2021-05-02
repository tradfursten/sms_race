defmodule Smsrace.SMSRace.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :name, :string
    field :nr, :integer
    field :phonenumber, :string
    field :status, :string
    belongs_to :race, Smsrace.SMSRace.Race
    has_many :passages, Smsrace.SMSRace.Passage

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:nr, :name, :phonenumber, :race_id, :status])
    |> validate_inclusion(:status, ["-", "Started", "Finished", "DNS", "DNF"])
    |> validate_required([:nr, :name, :phonenumber, :status])
  end
end
