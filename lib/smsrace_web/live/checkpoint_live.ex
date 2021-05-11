defmodule SmsraceWeb.CheckpointLive do
  use SmsraceWeb, :live_view

  def mount(%{"id" => checkpoint_id}, _session, socket) do

    checkpoint = Smsrace.SMSRace.get_checkpoint!(checkpoint_id)
    race = Smsrace.SMSRace.get_race_with_participants!(checkpoint.race_id)
    passages = Smsrace.SMSRace.list_passages_by_checkpoint_id(String.to_integer(checkpoint_id))
    |> list_passages_with_difference(race.start)

    missing_passages = missing_passages(race.participants, passages)

    {:ok, assign(socket, checkpoint: checkpoint, race: race, passages: passages, missing_passages: missing_passages )}

  end


  @imp true
  def handle_event("add-passage", _, socket) do
    IO.puts("test")
    {:noreply, socket}
  end

  def missing_passages(participants, passages) do
    pa = passages
    |> Enum.map(&(&1.participant_id))

    IO.inspect(pa)
    missing = participants
    |> Enum.filter(fn p ->
      Enum.member?(pa, p.id) == false
    end)

    missing
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
