defmodule Smsrace.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :number, :string
    field :emergency, :string
    has_many :races, Smsrace.SMSRace.Race
    has_many :users, Smsrace.Accounts.User


    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :number, :emergency])
    |> validate_required([:name, :number, :emergency])
  end
end
