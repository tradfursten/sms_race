defmodule SmsraceWeb.ExternalApiController do
  use SmsraceWeb, :controller

  require Logger


  alias Smsrace.SMSRace

  def create(conn, %{"id" => id} = params) do
    Logger.debug "Var value: #{inspect(params)}"
    new_message = params
    |> Map.delete("id")
    |> Map.put("api_id", id)

    case SMSRace.create_message(new_message) do
      {:ok, %{id: message_id, from: from, message: message, created: created} = persisted_message} ->
        participant = SMSRace.find_participant(from)
        checkpoint = find_checkpoint(message, participant)
        case create_passage(participant, checkpoint, created, message_id) do
          {:ok, %{participant_id: _participant_id, checkpoint_id: nil}} ->
            persisted_message
            |> SMSRace.update_message(%{handled: false})
          {:ok, %{participant_id: _participant_id, checkpoint_id: _checkpoint_id}} ->
            persisted_message
            |> SMSRace.update_message(%{handled: true})
          {:error, reason} ->
            Logger.error("Something went wrong when creating passage: #{inspect(reason)}")
        end
        conn
        |> send_resp(200, "")
      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> send_resp(500, "Could not save message")
    end
  end

  def incomming_call(conn, _params) do
    json(conn, %{"connect" => "+46734348420"})
  end

  defp find_checkpoint(_message, []), do: []

  defp find_checkpoint(message, [%{race_id: race_id}]), do: SMSRace.find_checkpoint(message, race_id)

  defp find_checkpoint(_message, _participant ), do: []

  defp create_passage([], _checkpoint, _at, _id), do: {:error, "No participant"}

  defp create_passage([%{id: participant_id}], [], at, message_id) do
    %{participant_id: participant_id, at: at, message_id: message_id}
    |> SMSRace.create_passage
  end

  defp create_passage([participant], [checkpoint], at, message_id) do
    %{participant_id: participant.id, checkpoint_id: checkpoint.id, at: at, message_id: message_id}
    |> SMSRace.create_passage
  end

end
