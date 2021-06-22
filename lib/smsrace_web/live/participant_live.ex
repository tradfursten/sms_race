defmodule SmsraceWeb.ParticipantLive do
  use SmsraceWeb, :live_view

  @impl true
  def mount(%{"id" => participant_id}, session, socket) do

    participant = Smsrace.Participant.get_participant_with_passages!(participant_id)
    race = Smsrace.SMSRace.get_race_with_checkpoints!(participant.race_id)
    start = participant.passages
    |> Enum.filter(fn p -> is_nil(p.checkpoint) == false end)
    |> Enum.find(&(&1.checkpoint.type == "start"))

    passages = participant.passages
    |> Enum.filter(fn p -> !is_nil(p.checkpoint) end)
    |> list_passages_with_difference(start)
    |> Enum.sort(fn p1, p2 -> p1.duration_s >= p2.duration_s end)
    |> Enum.reverse()


    missing_checkpoints = race.checkpoints
    |> missing_passages(participant.passages)
    |> Enum.filter(fn m_c -> m_c.type != "pre-start" end )
    |> Enum.sort(&sort_checkpoints/2)

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
    Smsrace.TopicHelper.subscribe_passage_by_participant(participant.id)
    {:ok, assign(socket, participant: participant, race: race, passages: passages, owns_race: owns_race, missing_checkpoints: missing_checkpoints)}
  end

  @impl true
  def handle_info({:passage_saved, _}, %{assigns: %{messages: _}} = socket) do
    IO.puts("new passage")
    {:noreply, socket}
  end


  @impl true
  def handle_event("add-passage", %{"passage_at" => passage_at, "checkpoint_id" => checkpoint_id}, socket) do
    Smsrace.SMSRace.create_passage(%{checkpoint_id: checkpoint_id, at: passage_at, participant_id: socket.assigns.participant.id})
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-passage", %{"passage_id" => id}, socket) do
    Smsrace.SMSRace.get_passage!(id)
    |> Smsrace.SMSRace.delete_passage()
    {:noreply, socket}
  end

  defp sort_checkpoints(c1, c2) do
      c1_check = case c1.type do
        "start" ->
          {:done, false}
        _ ->
          {:not_done, c1.number <= c2.number}
      end

      case c1_check do
        {:not_done, res} ->
          case c2.type do
            "start" ->
              false
              _ ->
                res
          end
        {:done, res} ->
          res
      end
  end

  def missing_passages(checkpoints, passages) do
    pa = passages
    |> Enum.map(&(&1.checkpoint_id))

    checkpoints
    |> Enum.filter(fn c -> Enum.member?(pa, c.id) == false end)
  end

  defp list_passages_with_difference(passages, %{at: start}) do
    passages
    |> Enum.map(fn p ->
      p
      |> Map.from_struct
      |> Map.put(:duration_s, DateTime.diff(p.at, start))
      |> Map.put(:duration, Seconds.to_hh_mm_ss(DateTime.diff(p.at, start)))
    end)
  end

  defp list_passages_with_difference([], _), do: []


  def pretty_print_date(date) do
    :io_lib.format("~2..0B:~2..0B:~2..0B", [date.hour, date.minute, date.second])
    |> IO.iodata_to_binary()
  end
end
