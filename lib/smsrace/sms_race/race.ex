defmodule Smsrace.SMSRace.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :name, :string
    field :start, :utc_datetime
    field :type, :string
    belongs_to :user, Smsrace.Accounts.User
    has_many :checkpoints, Smsrace.SMSRace.Checkpoint
    has_many :participants, Smsrace.SMSRace.Participant

    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :start, :type])
    |> validate_required([:name, :start, :type])
  end
end
