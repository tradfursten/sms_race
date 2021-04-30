defmodule SmsraceWeb.CheckpointLive do
  use SmsraceWeb, :live_view

  def mount(%{"id" => checkpoint_id}, _session, socket) do

    checkpoint = Smsrace.SMSRace.get_checkpoint!(checkpoint_id)
    race = Smsrace.SMSRace.get_race_with_participants!(checkpoint.race_id)
    passages = list_passages_with_difference(Smsrace.SMSRace.list_passages_by_checkpoint_id(String.to_integer(checkpoint_id)), race.start)

    missing_passages = race.participants
    |> Enum.filter(&(passages
      |> Enum.filter(fn p ->
        p.participant_id == &1
      end)
      |> Enum.empty?))
    {:ok, assign(socket, checkpoint: checkpoint, race: race, passages: passages, missing_passages: missing_passages )}

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
