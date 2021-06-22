defmodule SmsraceWeb.ParticipantController do
  use SmsraceWeb, :controller

  alias Smsrace.SMSRace
  alias Smsrace.SMSRace.Participant

  def index(conn, _params) do
    user = conn.assigns.current_user
    participants = Smsrace.Participant.list_participants_with_race()
    render(conn, "index.html", participants: participants)
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    user = conn.assigns.current_user
    changeset = Smsrace.Participant.change_participant(%Participant{})
    races = SMSRace.list_races(user.organization_id)
    |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, races: races)
  end

  def create(conn, %{"participant" => participant_params}) do
    user = conn.assigns.current_user
    case Smsrace.Participant.create_participant(participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant created successfully.")
        |> redirect(to: Routes.participant_path(conn, :show, participant))

      {:error, %Ecto.Changeset{} = changeset} ->
        races = SMSRace.list_races(user.organization_id)
        |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset, races: races)
    end
  end

  def show(conn, %{"id" => id}) do
    participant = Smsrace.Participant.get_participant!(id)
    render(conn, "show.html", participant: participant)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    participant = Smsrace.Participant.get_participant!(id)
    races = SMSRace.list_races(user.organization_id)
    |> Enum.map(&{&1.name, &1.id})
    changeset = Smsrace.Participant.change_participant(participant)
    render(conn, "edit.html", participant: participant, changeset: changeset, races: races)
  end

  def update(conn, %{"id" => id, "participant" => participant_params}) do
    user = conn.assigns.current_user
    participant = Smsrace.Participant.get_participant!(id)

    case Smsrace.Participant.update_participant(participant, participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant updated successfully.")
        |> redirect(to: Routes.participant_path(conn, :show, participant))

      {:error, %Ecto.Changeset{} = changeset} ->
        races = SMSRace.list_races(user.organization_id)
        |> Enum.map(&{&1.name, &1.id})
        render(conn, "edit.html", participant: participant, changeset: changeset, races: races)
    end
  end

  def delete(conn, %{"id" => id}) do
    participant = Smsrace.Participant.get_participant!(id)
    {:ok, _participant} = Smsrace.Participant.delete_participant(participant)

    conn
    |> put_flash(:info, "Participant deleted successfully.")
    |> redirect(to: Routes.participant_path(conn, :index))
  end
end
