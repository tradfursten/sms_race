defmodule Smsrace.Participant do

  import Ecto.Query, warn: false
  alias Smsrace.Repo

  alias Smsrace.SMSRace.Participant

  require Logger

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants(organization_id) do
    Participant
    |> join(:left, [p], r in Race, on: p.race_id == r.id and r.organization_id == ^organization_id)
    |> select([p], {p})
  end

  def list_participants_with_race do
    Participant
    |> Repo.all
    |> Repo.preload(:race)
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.

  ## Examples

      iex> get_participant!(123)
      %Participant{}

      iex> get_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  def get_participant_with_passages!(id) do
    Participant
    |> Repo.get!(id)
    |> Repo.preload([passages: [:checkpoint]])

  end


  @spec find_participant(any) :: any
  def find_participant(n) do
    query = from p in Participant, where: p.phonenumber == ^n and p.status not in ["DNS", "DNF"], select: p
    Repo.all(query)
  end

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{field: value})
      {:ok, %Participant{}}

      iex> create_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participant(attrs \\ %{}) do
    %Participant{}
    |> Participant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a participant.

  ## Examples

      iex> update_participant(participant, %{field: new_value})
      {:ok, %Participant{}}

      iex> update_participant(participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(participant)
      %Ecto.Changeset{data: %Participant{}}

  """
  def change_participant(%Participant{} = participant, attrs \\ %{}) do
    Participant.changeset(participant, attrs)
  end


  def update_participant_status(attrs \\ nil)
  def update_participant_status(%{participant: participant, checkpoint: checkpoint}) do
    update_participant_status_by_checkpoint(participant.id, participant.status, checkpoint.type)
  end
  def update_participant_status(_) do
  end

  defp update_participant_status_by_checkpoint(id, "-", "start") do
    get_participant!(id)
    |> update_participant(%{status: "started"})
  end

  defp update_participant_status_by_checkpoint(id, "started", "finish") do
    get_participant!(id)
    |> update_participant(%{status: "finished"})
  end

  defp update_participant_status_by_checkpoint(_,_,_) do
  end

end
