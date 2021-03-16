defmodule Smsrace.SMSRace.Passage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passages" do
    field :at, :utc_datetime
    field :checkpoint_id, :id
    field :participant_id, :id

    timestamps()
  end

  @doc false
  def changeset(passage, attrs) do
    passage
    |> cast(attrs, [:at])
    |> validate_required([:at])
  end
end
