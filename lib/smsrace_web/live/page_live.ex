defmodule SmsraceWeb.PageLive do
  use SmsraceWeb, :live_view

  require Logger

  @impl true
  def mount(_params, session, socket) do
    IO.inspect(session)
    Phoenix.PubSub.subscribe(Smsrace.PubSub, "messages")
    participants = Smsrace.SMSRace.list_participants()
    races = Smsrace.SMSRace.list_races_with_checkpoints
    selection = :messages
    socket = socket
    |> assign(selection: selection, scope: :unhandled, participants: participants, races: races, query: "")
    |> update_messages()
    {:ok, socket}
  end

  @impl true
  def handle_info({:message_saved, _}, %{assigns: %{messages: _}} = socket) do
    socket = socket
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("select-participant", %{"message" => message_id}, socket) do
    selection = :participants
    message = Smsrace.SMSRace.get_message!(String.to_integer(message_id))
    {:noreply, assign(socket, selection: selection, selected_message: message)}
  end

  @impl true
  def handle_event("assign-participant-to-message", %{"participant" => participant_id}, socket) do
    selection = :messages
    message = socket.assigns.selected_message
    %{participant_id: participant_id, at: message.created, message_id: message.id}
    |> Smsrace.SMSRace.create_passage
    socket = socket
    |> assign(selection: selection)
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("remove-participant", %{"message" => message_id}, socket) do
    message = Smsrace.SMSRace.get_message!(message_id)

    message_id
    |> String.to_integer
    |> Smsrace.SMSRace.get_passage_by_message_id!
    |> Smsrace.SMSRace.delete_passage

    Smsrace.SMSRace.update_message(message, %{handled: false})

    socket = socket
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("remove-checkpoint", %{"message" => message_id}, socket) do
    message = Smsrace.SMSRace.get_message!(message_id)

    message_id
    |> String.to_integer
    |> Smsrace.SMSRace.get_passage_by_message_id!
    |> Smsrace.SMSRace.update_passage(%{checkpoint_id: nil})

    Smsrace.SMSRace.update_message(message, %{handled: false})

    socket = socket
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("select-checkpoint", %{"message" => message_id}, socket) do
    selection = :checkpoints
    message = Smsrace.SMSRace.get_message_with_passage!(String.to_integer(message_id))
    participant = Smsrace.SMSRace.get_participant_with_passages!(message.passage.participant_id)
    [selected_race ] = socket.assigns.races
    |> Enum.filter(&(&1.id == participant.race_id))
    {:noreply, assign(socket, selection: selection, selected_message: message, selected_race: selected_race, selected_participant: participant)}
  end

  @impl true
  def handle_event("assign-checkpoint-to-message", %{"checkpoint" => checkpoint_id}, socket) do
    selection = :messages
    message = socket.assigns.selected_message
    passage = Smsrace.SMSRace.get_passage_by_message_id!(message.id)
    Smsrace.SMSRace.update_passage(passage, %{checkpoint_id: String.to_integer(checkpoint_id)})
    Smsrace.SMSRace.update_message(message, %{handled: true})
    socket = socket
    |> assign(selection: selection)
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-message", %{"message" => message_id}, socket) do
    selection = :messages
    message = Smsrace.SMSRace.get_message_with_passage!(message_id)
    Smsrace.SMSRace.update_message(message, %{deleted: DateTime.utc_now()})
    socket = socket
    |> assign(selection: selection)
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("home", _event, socket) do
    selection = :messages
    socket = socket
    |> assign(selection: selection)
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("show-all", _event, socket) do
    socket = socket
    |> assign(scope: :all)
    |> update_messages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("show-unhandled", _event, socket) do
    socket = socket
    |> assign(scope: :unhandled)
    |> update_messages()
    {:noreply, socket}
  end

  defp update_messages(socket) do
    messages = case socket.assigns.scope do
      :all -> Smsrace.SMSRace.list_messages_sorted(:all)
      _ -> Smsrace.SMSRace.list_messages_sorted()
    end
    assign(socket, messages: messages)
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
