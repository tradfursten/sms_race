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
  def list_races(organization_id) do
    Race
    |> where([r], r.organization_id == ^organization_id)
    |> Repo.all()
    |> Enum.map(&Race.add_display_time/1)
  end

  def list_races_with_checkpoints(organization_id) do
    Repo.preload(list_races(organization_id), :checkpoints)
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
  def get_race!(id, organization_id) do
    Race
    |> where([r], r.organization_id == ^organization_id)
    |> Repo.get!(id)
    |> Race.add_display_time()
  end

  def get_race!(id) do
    Race
    |> Repo.get!(id)
    |> Race.add_display_time()
  end

  def get_race_with_participants!(id, organization_id) do
    get_race!(id, organization_id)
    |> Repo.preload(:participants)
  end

  def get_race_with_participants!(id) do
    get_race!(id)
    |> Repo.preload(:participants)
  end

  def get_race_with_checkpoints!(id) do
    get_race!(id)
    |> Repo.preload(:checkpoints)
  end
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

  def start_race(race_id, started_at) do

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

  def list_checkpoints_with_race do
    Checkpoint
    |> Repo.all
    |> Repo.preload(:race)
  end

  def find_checkpoint(code, race_id) do
    # todo match ignore case
    code = String.downcase(code)
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

  def list_passages_with_race do
    Passage
    |> Repo.all
    |> Repo.preload(:race)
  end

  def list_passages_by_checkpoint_id(checkpoint_id) do
    Passage
    |> where(checkpoint_id: ^checkpoint_id)
    |> order_by(asc: :at)
    |> Repo.all
    |> Repo.preload(:participant)
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

  def get_passage_by_message_id!(message_id) do
    query = from p in Passage, where: p.message_id == ^message_id, select: p
    Repo.one!(query)
  end

  @doc """
  Creates a passage.

  ## Examples

      iex> create_passage(%{field: value})
      {:ok, %Passage{}}

      iex> create_passage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_passage(attrs \\ %{}) do
    passage = %Passage{}
    |> Passage.changeset(attrs)
    |> Repo.insert()

    Smsrace.Participant.update_participant_status(attrs)
    case passage do
      {:ok, p} ->
        Smsrace.TopicHelper.publish_passage(p)
    end
    passage
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

    Smsrace.TopicHelper.publish_passage(passage)
    passage
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
    Smsrace.TopicHelper.publish_passage(passage)
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

  def list_messages_sorted(number) do
    Message
    |> where([m], m.handled == false and is_nil(m.deleted) and m.to == ^number)
    |> order_by(desc: :created)
    |> Repo.all
    |> Repo.preload([passage: [:checkpoint, :participant]])
  end

  def list_messages_sorted(number, :all) do
    Message
    |> where([m], is_nil(m.deleted) and m.to == ^number)
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

  def get_message_with_passage!(id) do
    Message
    |> Repo.get!(id)
    |> Repo.preload([passage: [:checkpoint, :participant]])
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    message = %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    case message do
      {:ok, m} ->
        Smsrace.TopicHelper.publish_message(m)
    end
    message
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

    Smsrace.TopicHelper.publish_message(message)
    message
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
