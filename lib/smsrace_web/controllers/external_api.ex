defmodule SmsraceWeb.ExternalApiController do
  use SmsraceWeb, :controller

  require Logger


  alias Smsrace.SMSRace

  def create(conn, %{"id" => id} = params) do
    Logger.info "Var value: #{inspect(params)}"
    new_message = params
    |> Map.delete("id")
    |> Map.put("api_id", id)

    case SMSRace.create_message(new_message) do
      {:ok, %{id: message_id, from: from, message: message, created: created} = persisted_message} ->
        participant = Smsrace.Participant.find_participant(from)
        checkpoint = find_checkpoint(String.trim(message), participant)
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
      _ ->
        conn
        |> send_resp(500, "Could not save message")
    end
  end

  def incomming_call(conn, %{"to" => to}) do
    connect_to = case Smsrace.Accounts.find_organization_by_incomming(to) do
      %{emergency: emergency} -> emergency
      _ -> "+46734348420"
    end
    json(conn, %{"connect" => connect_to})
  end

  defp find_checkpoint(_message, []), do: []

  defp find_checkpoint(message, [%{race_id: race_id}]), do: SMSRace.find_checkpoint(message, race_id)

  defp find_checkpoint(_message, _participant ), do: []

  defp create_passage([], _checkpoint, _at, _id), do: {:error, "No participant"}

  defp create_passage([%{id: participant_id} = participant], [], at, message_id) do
    %{participant_id: participant_id, at: at, message_id: message_id, participant: participant}
    |> SMSRace.create_passage
  end

  defp create_passage([participant], [checkpoint], at, message_id) do
    %{participant_id: participant.id, checkpoint_id: checkpoint.id, at: at, message_id: message_id, participant: participant, checkpoint: checkpoint}
    |> SMSRace.create_passage
  end

end
