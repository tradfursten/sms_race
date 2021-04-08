defmodule Smsrace.SMSRace.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :created, :utc_datetime
    field :direction, :string
    field :from, :string
    field :api_id, :string
    field :message, :string
    field :to, :string
    field :handled, :boolean

    has_one :passage, Smsrace.SMSRace.Passage

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:api_id, :from, :to, :message, :direction, :created])
    |> validate_required([:api_id, :from, :to, :message, :direction, :created])
  end
end
