defmodule Smsrace.SMSRace do
  @moduledoc """
  The SMSRace context.
  """

  import Ecto.Query, warn: false
  alias Smsrace.Repo

  alias Smsrace.SMSRace.Race

  @doc """
  Returns the list of races.

  ## Examples

      iex> list_races()
      [%Race{}, ...]

  """
  def list_races do
    Repo.all(Race)
  end

  def list_races_with_checkpoints do
    Race
    |> Repo.all()
    |> Repo.preload(:checkpoints)
  end

  @doc """
  Gets a single race.

  Raises `Ecto.NoResultsError` if the Race does not exist.

  ## Examples

      iex> get_race!(123)
      %Race{}

      iex> get_race!(456)
      ** (Ecto.NoResultsError)

  """
  def get_race!(id), do: Repo.get!(Race, id)

  @doc """
  Creates a race.

  ## Examples

      iex> create_race(%{field: value})
      {:ok, %Race{}}

      iex> create_race(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_race(attrs \\ %{}) do
    %Race{}
    |> Race.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a race.

  ## Examples

      iex> update_race(race, %{field: new_value})
      {:ok, %Race{}}

      iex> update_race(race, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_race(%Race{} = race, attrs) do
    race
    |> Race.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a race.

  ## Examples

      iex> delete_race(race)
      {:ok, %Race{}}

      iex> delete_race(race)
      {:error, %Ecto.Changeset{}}

  """
  def delete_race(%Race{} = race) do
    Repo.delete(race)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking race changes.

  ## Examples

      iex> change_race(race)
      %Ecto.Changeset{data: %Race{}}

  """
  def change_race(%Race{} = race, attrs \\ %{}) do
    Race.changeset(race, attrs)
  end

  alias Smsrace.SMSRace.Participant

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants do
    Repo.all(Participant)
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


  def find_participant(n) do
    query = from p in Participant, where: p.phonenumber == ^n, select: p
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

  alias Smsrace.SMSRace.Checkpoint

  @doc """
  Returns the list of checkpoints.

  ## Examples

      iex> list_checkpoints()
      [%Checkpoint{}, ...]

  """
  def list_checkpoints do
    Repo.all(Checkpoint)
  end

  def find_checkpoint(code, race_id) do
    query = from c in Checkpoint, where: c.code == ^code and c.race_id == ^race_id, select: c
    Repo.all(query)
  end

  @doc """
  Gets a single checkpoint.

  Raises `Ecto.NoResultsError` if the Checkpoint does not exist.

  ## Examples

      iex> get_checkpoint!(123)
      %Checkpoint{}

      iex> get_checkpoint!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checkpoint!(id), do: Repo.get!(Checkpoint, id)

  @doc """
  Creates a checkpoint.

  ## Examples

      iex> create_checkpoint(%{field: value})
      {:ok, %Checkpoint{}}

      iex> create_checkpoint(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checkpoint(attrs \\ %{}) do
    %Checkpoint{}
    |> Checkpoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checkpoint.

  ## Examples

      iex> update_checkpoint(checkpoint, %{field: new_value})
      {:ok, %Checkpoint{}}

      iex> update_checkpoint(checkpoint, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checkpoint(%Checkpoint{} = checkpoint, attrs) do
    checkpoint
    |> Checkpoint.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a checkpoint.

  ## Examples

      iex> delete_checkpoint(checkpoint)
      {:ok, %Checkpoint{}}

      iex> delete_checkpoint(checkpoint)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checkpoint(%Checkpoint{} = checkpoint) do
    Repo.delete(checkpoint)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checkpoint changes.

  ## Examples

      iex> change_checkpoint(checkpoint)
      %Ecto.Changeset{data: %Checkpoint{}}

  """
  def change_checkpoint(%Checkpoint{} = checkpoint, attrs \\ %{}) do
    Checkpoint.changeset(checkpoint, attrs)
  end

  alias Smsrace.SMSRace.Passage

  @doc """
  Returns the list of passages.

  ## Examples

      iex> list_passages()
      [%Passage{}, ...]

  """
  def list_passages do
    Repo.all(Passage)
  end

  @doc """
  Gets a single passage.

  Raises `Ecto.NoResultsError` if the Passage does not exist.

  ## Examples

      iex> get_passage!(123)
      %Passage{}

      iex> get_passage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_passage!(id), do: Repo.get!(Passage, id)

  @doc """
  Creates a passage.

  ## Examples

      iex> create_passage(%{field: value})
      {:ok, %Passage{}}

      iex> create_passage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_passage(attrs \\ %{}) do
    %Passage{}
    |> Passage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a passage.

  ## Examples

      iex> update_passage(passage, %{field: new_value})
      {:ok, %Passage{}}

      iex> update_passage(passage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_passage(%Passage{} = passage, attrs) do
    passage
    |> Passage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a passage.

  ## Examples

      iex> delete_passage(passage)
      {:ok, %Passage{}}

      iex> delete_passage(passage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_passage(%Passage{} = passage) do
    Repo.delete(passage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking passage changes.

  ## Examples

      iex> change_passage(passage)
      %Ecto.Changeset{data: %Passage{}}

  """
  def change_passage(%Passage{} = passage, attrs \\ %{}) do
    Passage.changeset(passage, attrs)
  end

  alias Smsrace.SMSRace.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  def list_messages_sorted do
    Message
    |> where(handled: false)
    |> order_by(desc: :created)
    |> Repo.all
    |> Repo.preload([passage: [:checkpoint, :participant]])
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
