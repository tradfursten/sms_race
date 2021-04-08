defmodule Smsrace.SMSRace.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkpoints" do
    field :code, :string
    field :cutoff, :utc_datetime
    field :distance, :float
    field :name, :string
    belongs_to :race, Smsrace.SMSRace.Race
    has_many :passages, Smsrace.SMSRace.Passage

    timestamps()
  end

  @doc false
  def changeset(checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:name, :distance, :cutoff, :code, :race_id])
    |> validate_required([:name, :distance, :code])
  end
end
