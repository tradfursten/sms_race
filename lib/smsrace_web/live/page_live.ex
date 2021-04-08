defmodule SmsraceWeb.PageLive do
  use SmsraceWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    IO.inspect(session)
    Phoenix.PubSub.subscribe(Smsrace.PubSub, "messages")
    messages = Smsrace.SMSRace.list_messages_sorted()
    participants = Smsrace.SMSRace.list_participants()
    races = Smsrace.SMSRace.list_races_with_checkpoints
    selection = :messages
    {:ok, assign(socket, selection: selection, scope: :handled, messages: messages, participants: participants, races: races, query: "")}
  end

  @impl true
  def handle_info({:message_saved, _}, %{assigns: %{messages: _}} = socket) do
    {:noreply, assign(socket, messages: Smsrace.SMSRace.list_messages_sorted())}
  end

  @impl true
  def handle_event("select-participant", %{"message" => message_id}, socket) do
    selection = :participants
    message = Smsrace.SMSRace.get_message!(String.to_integer(message_id))
    {:noreply, assign(socket, selection: selection, selected_message: message)}
  end

  @impl true
  def handle_event("assign-participant-to-message", %{"participant" => participant_id}, socket) do
    selection = :checkpoints
    #message = Smsrace.SMSRace.get_message!(String.to_integer(socket.assigns.message))
    #participant = SMSRace.get_participant!(String.to_integer(participant_id))
    message = socket.assigns.selected_message
    %{participant_id: participant_id, at: message.created, message_id: message.id}
    |> Smsrace.SMSRace.create_passage
    {:noreply, assign(socket, selection: selection)}
  end

  @impl true
  def handle_event("select-checkpoint", %{"message" => message_id}, socket) do
    selection = :checkpoints
    message = Smsrace.SMSRace.get_message!(String.to_integer(message_id))
    {:noreply, assign(socket, selection: selection, selected_message: message)}
  end

  @impl true
  def handle_event("home", _event, socket) do
    selection = :messages
    {:noreply, assign(socket, selection: selection)}
  end

  defp pretty_print_date(date) do
    :io_lib.format("~2..0B:~2..0B:~2..0B", [date.hour, date.minute, date.second])
    |> IO.iodata_to_binary()
  end

  defp sort_participants(participants, from) do
    participants
    |> Enum.sort(&(String.jaro_distance(&1.phonenumber, from) >= String.jaro_distance(&2.phonenumber, from)))
  end
end
