defmodule Smsrace.CustomQueries do

  import Ecto.Query, warn: false
  alias Smsrace.Repo

  alias Smsrace.SMSRace.Passage
  alias Smsrace.SMSRace.Participant
  alias Smsrace.SMSRace.Checkpoint

  def fetch_passages_for_checkpoint(checkpoint_id) do
    Passage
    |> join(:left, [p], p2 in Participant, on: p.participant_id == p2.id)
    |> join(:left, [p, p2], p3 in Passage, on: p2.id == p3.participant_id)
    |> join(:left, [p, p2, p3], c in Checkpoint, on: p3.checkpoint_id == c.id)
    |> where([p, p2, p3, c], p.checkpoint_id == ^checkpoint_id and c.type == "start")
    |> select([p, p2, p3], %{"name" => p2.name, "participant_id" => p.participant_id, "at" => p.at, "duration" => p.at - p3.at, "id" => p.id})
    |> order_by(asc: 3)
    |> Repo.all()
  end

end
