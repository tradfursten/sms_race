defmodule Smsrace.SMSRace.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkpoints" do
    field :code, :string
    field :cutoff, :utc_datetime
    field :distance, :float
    field :name, :string
    field :race_id, :id

    timestamps()
  end

  @doc false
  def changeset(checkpoint, attrs) do
    checkpoint
    |> cast(attrs, [:name, :distance, :cutoff, :code])
    |> validate_required([:name, :distance, :cutoff, :code])
  end
end
