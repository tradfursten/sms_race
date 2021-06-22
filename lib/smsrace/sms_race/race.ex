defmodule Smsrace.SMSRace.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :name, :string
    field :start, :utc_datetime
    field :type, :string
    field :timezone, :string, default: "Europe/Stockholm"
    field :display_time, :naive_datetime, virtual: true
    belongs_to :organization, Smsrace.Accounts.Organization
    has_many :checkpoints, Smsrace.SMSRace.Checkpoint
    has_many :participants, Smsrace.SMSRace.Participant

    timestamps()
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :start, :type, :timezone, :display_time, :organization_id])
    |> validate_inclusion(:timezone, Tzdata.zone_list())
    |> compute_time
    |> validate_required([:name, :start, :type, :timezone, :organization_id])
  end

  defp compute_time(changeset) do
    start = case get_field(changeset, :display_time) do
              nil -> DateTime.now!("Europe/Stockholm")
              computed -> computed |> DateTime.from_naive!(get_field(changeset, :timezone)) |> DateTime.shift_zone!("Etc/UTC")
    end
    changeset
    |> put_change(:start, start)
  end

  def add_display_time(%__MODULE__{} = race) do
    display_time = race.start
    |> DateTime.shift_zone!(race.timezone)
    |> DateTime.to_naive()

    %{race | display_time: display_time}
  end
end
