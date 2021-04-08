defmodule Smsrace.SMSRace.Passage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passages" do
    field :at, :utc_datetime
    belongs_to :message, Smsrace.SMSRace.Message
    belongs_to :participant, Smsrace.SMSRace.Participant
    belongs_to :checkpoint, Smsrace.SMSRace.Checkpoint

    timestamps()
  end

  @doc false
  def changeset(passage, attrs) do
    passage
    |> cast(attrs, [:at, :participant_id, :checkpoint_id, :message_id])
    |> validate_required([:at])
  end
end
