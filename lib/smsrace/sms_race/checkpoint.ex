defmodule Smsrace.SMSRace.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkpoints" do
    field :code, :string
    field :distance, :float
    field :name, :string
    field :type, :string
    field :info, :string
    belongs_to :race, Smsrace.SMSRace.Race
    has_many :passages, Smsrace.SMSRace.Passage

    timestamps()
  end

  @doc false
  def changeset(checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:name, :distance, :code, :race_id, :type, :info])
    |> validate_required([:name, :type])
  end
end
