defmodule SmsraceWeb.CheckpointLive do
  use SmsraceWeb, :live_view

  def mount(%{"id" => checkpoint_id}, _session, socket) do

    checkpoint = Smsrace.SMSRace.get_checkpoint!(checkpoint_id)
    race = Smsrace.SMSRace.get_race!(checkpoint.race_id)
    passages = Smsrace.SMSRace.list_passages_by_checkpoint_id(String.to_integer(checkpoint_id))
    [first | _tail ] = passages
    passages = passages
    |> Enum.map(fn p ->
      p
      |> Map.from_struct
      |> Map.put(:duration, Seconds.to_hh_mm_ss(DateTime.diff(p.at, race.start)))
      |> Map.put(:behind, Seconds.to_hh_mm_ss(DateTime.diff(p.at, first.at)))
    end)
    {:ok, assign(socket, checkpoint: checkpoint, race: race, passages: passages)}

  end

end
