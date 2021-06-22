defmodule SmsraceWeb.PageLive do
  use SmsraceWeb, :live_view

  require Logger

  @impl true
  def mount(_params, session, socket) do
    IO.inspect(session)
    # On mount:
    # Check that we are a logged in  user and have a session user id
    # Pull our current races (somehow!)
    redirect = case connected?(socket) do
      true ->
        user = Smsrace.Accounts.get_user_by_session_token(session["user_token"])
        case user.organization_id do
          nil ->
            {:redirect}
          _ ->
            case Smsrace.Accounts.get_organization(user.organization_id) do
              nil ->
                {:redirect}
              organization ->
                organization.number |> Smsrace.TopicHelper.subscribe_message()
                {:ok, organization}
            end
        end
      false ->
        {:noop}
    end
    case redirect do
      {:ok, organization} ->
        participants = Smsrace.Participant.list_participants(organization.id)
        races = Smsrace.SMSRace.list_races_with_checkpoints(organization.id)
        selection = :messages
        socket = socket
        |> assign(selection: selection, scope: :unhandled, participants: participants, races: races, query: "", number: organization.number)
        |> update_messages()
        {:ok, socket}
      {:noop} ->
        {:ok, assign(socket, selection: :message, scope: :unhandled, participants: [], races: [], query: "")}
      {:redirect} ->
        {:ok, push_redirect(socket, to: "/organizations")}
    end
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
    participant = Smsrace.Participant.get_participant_with_passages!(message.passage.participant_id)
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
    Smsrace.SMSRace.delete_passage(message.passage)
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
    case socket.assigns.number do
      nil ->
        assign(socket, messages: [])
      number ->
        messages = case socket.assigns.scope do
          :all -> Smsrace.SMSRace.list_messages_sorted(number, :all)
          _ -> Smsrace.SMSRace.list_messages_sorted(number)
        end
        assign(socket, messages: messages)
    end
  end

  defp pretty_print_date(date) do
    :io_lib.format("~2..0B:~2..0B:~2..0B", [date.hour, date.minute, date.second])
    |> IO.iodata_to_binary()
  end

  defp sort_participants(participants, from) do
    participants
    |> Enum.sort(&(String.jaro_distance(&1.phonenumber, from) >= String.jaro_distance(&2.phonenumber, from)))
  end

  defp link_message(message) do
    message
    |> Phoenix.HTML.html_escape
    |> Phoenix.HTML.safe_to_string
    |> AutoLinker.link(new_window: true, rel: false, scheme: true, class: "text-blue-400 underline pointer")
  end
end
