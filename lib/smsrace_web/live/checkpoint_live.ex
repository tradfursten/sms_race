defmodule SmsraceWeb.CheckpointLive do
  use SmsraceWeb, :live_view

  require Logger

  @impl true
  def mount(%{"id" => checkpoint_id}, session, socket) do


    checkpoint = Smsrace.SMSRace.get_checkpoint!(checkpoint_id)
    race = Smsrace.SMSRace.get_race_with_participants!(checkpoint.race_id)

    owns_race = case connected?(socket) do
      true ->
        case is_nil(session["user_token"]) do
          false ->
            user = Smsrace.Accounts.get_user_by_session_token(session["user_token"])
            r_orgid = race.organization_id
            case user.organization_id do
              ^r_orgid -> true
              _ -> false
            end
          true -> false
        end
      false -> false
    end

    Smsrace.TopicHelper.subscribe_passage_by_checkpoint(checkpoint.id)

    socket = socket
    |> assign(race: race, checkpoint: checkpoint, owns_race: owns_race)
    |> update_passages()
    {:ok, socket}

  end

  @impl true
  def handle_info({:passage_saved, _}, %{assigns: %{messages: _}} = socket) do
    socket = socket
    |> update_passages()
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-passage", %{"passage_at" => passage_at, "participant_id" => participant_id} = params, socket) do
    IO.inspect(params)
    Smsrace.SMSRace.create_passage(%{checkpoint_id: socket.assigns.checkpoint.id, at: passage_at, participant_id: participant_id})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-passage", %{"id" => id}, socket) do
    Smsrace.SMSRace.get_passage!(id)
    |> Smsrace.SMSRace.delete_passage()
    {:noreply, socket}
  end

  def update_passages(socket) do
    race = socket.assigns.race
    checkpoint_id = socket.assigns.checkpoint.id
    passages = Smsrace.CustomQueries.fetch_passages_for_checkpoint(checkpoint_id)

    missing_passages = missing_passages(race.participants, passages)
    assign(socket, passages: passages, missing_passages: missing_passages)
  end

  def missing_passages(participants, passages) do
    pa = passages
    |> Enum.map(&(&1["participant_id"]))

    participants
    |> Enum.filter(fn p -> Enum.member?(pa, p.id) == false end)
  end


  defp list_passages_with_difference([first | _tail] = passages, start) do
    passages
    |> Enum.map(fn p ->
      p
      |> Map.from_struct
      |> Map.put(:duration, Seconds.to_hh_mm_ss(DateTime.diff(p.at, start)))
      |> Map.put(:behind, Seconds.to_hh_mm_ss(DateTime.diff(p.at, first.at)))
    end)
  end

  defp list_passages_with_difference([], _), do: []

end
