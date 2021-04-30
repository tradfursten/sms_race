defmodule SmsraceWeb.ParticipantController do
  use SmsraceWeb, :controller

  alias Smsrace.SMSRace
  alias Smsrace.SMSRace.Participant

  def index(conn, _params) do
    participants = SMSRace.list_participants_with_race()
    render(conn, "index.html", participants: participants)
  end

  def new(conn, _params) do
    changeset = SMSRace.change_participant(%Participant{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"participant" => participant_params}) do
    case SMSRace.create_participant(participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant created successfully.")
        |> redirect(to: Routes.participant_path(conn, :show, participant))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    participant = SMSRace.get_participant!(id)
    render(conn, "show.html", participant: participant)
  end

  def edit(conn, %{"id" => id}) do
    participant = SMSRace.get_participant!(id)
    changeset = SMSRace.change_participant(participant)
    render(conn, "edit.html", participant: participant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "participant" => participant_params}) do
    participant = SMSRace.get_participant!(id)

    case SMSRace.update_participant(participant, participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant updated successfully.")
        |> redirect(to: Routes.participant_path(conn, :show, participant))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", participant: participant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    participant = SMSRace.get_participant!(id)
    {:ok, _participant} = SMSRace.delete_participant(participant)

    conn
    |> put_flash(:info, "Participant deleted successfully.")
    |> redirect(to: Routes.participant_path(conn, :index))
  end
end
