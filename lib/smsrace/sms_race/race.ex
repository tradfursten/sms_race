defmodule Smsrace.SMSRace.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :name, :string
    field :start, :utc_datetime
    belongs_to :user, Smsrace.Accounts.User
    has_many :checkpoints, Smsrace.SMSRace.Checkpoint

    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :start])
    |> validate_required([:name, :start])
  end
end
