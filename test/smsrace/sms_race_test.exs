defmodule Smsrace.SMSRaceTest do
  use Smsrace.DataCase

  alias Smsrace.SMSRace

  describe "races" do
    alias Smsrace.SMSRace.Race

    @valid_attrs %{name: "some name", start: "2010-04-17T14:00:00Z"}
    @update_attrs %{name: "some updated name", start: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{name: nil, start: nil}

    def race_fixture(attrs \\ %{}) do
      {:ok, race} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SMSRace.create_race()

      race
    end

    test "list_races/0 returns all races" do
      race = race_fixture()
      assert SMSRace.list_races() == [race]
    end

    test "get_race!/1 returns the race with given id" do
      race = race_fixture()
      assert SMSRace.get_race!(race.id) == race
    end

    test "create_race/1 with valid data creates a race" do
      assert {:ok, %Race{} = race} = SMSRace.create_race(@valid_attrs)
      assert race.name == "some name"
      assert race.start == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_race/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SMSRace.create_race(@invalid_attrs)
    end

    test "update_race/2 with valid data updates the race" do
      race = race_fixture()
      assert {:ok, %Race{} = race} = SMSRace.update_race(race, @update_attrs)
      assert race.name == "some updated name"
      assert race.start == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_race/2 with invalid data returns error changeset" do
      race = race_fixture()
      assert {:error, %Ecto.Changeset{}} = SMSRace.update_race(race, @invalid_attrs)
      assert race == SMSRace.get_race!(race.id)
    end

    test "delete_race/1 deletes the race" do
      race = race_fixture()
      assert {:ok, %Race{}} = SMSRace.delete_race(race)
      assert_raise Ecto.NoResultsError, fn -> SMSRace.get_race!(race.id) end
    end

    test "change_race/1 returns a race changeset" do
      race = race_fixture()
      assert %Ecto.Changeset{} = SMSRace.change_race(race)
    end
  end

  describe "participants" do
    alias Smsrace.SMSRace.Participant

    @valid_attrs %{name: "some name", nr: 42, phonenumber: "some phonenumber"}
    @update_attrs %{name: "some updated name", nr: 43, phonenumber: "some updated phonenumber"}
    @invalid_attrs %{name: nil, nr: nil, phonenumber: nil}

    def participant_fixture(attrs \\ %{}) do
      {:ok, participant} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SMSRace.create_participant()

      participant
    end

    test "list_participants/0 returns all participants" do
      participant = participant_fixture()
      assert SMSRace.list_participants() == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert SMSRace.get_participant!(participant.id) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      assert {:ok, %Participant{} = participant} = SMSRace.create_participant(@valid_attrs)
      assert participant.name == "some name"
      assert participant.nr == 42
      assert participant.phonenumber == "some phonenumber"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SMSRace.create_participant(@invalid_attrs)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{} = participant} = SMSRace.update_participant(participant, @update_attrs)
      assert participant.name == "some updated name"
      assert participant.nr == 43
      assert participant.phonenumber == "some updated phonenumber"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = participant_fixture()
      assert {:error, %Ecto.Changeset{}} = SMSRace.update_participant(participant, @invalid_attrs)
      assert participant == SMSRace.get_participant!(participant.id)
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = SMSRace.delete_participant(participant)
      assert_raise Ecto.NoResultsError, fn -> SMSRace.get_participant!(participant.id) end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = SMSRace.change_participant(participant)
    end
  end

  describe "checkpoints" do
    alias Smsrace.SMSRace.Checkpoint

    @valid_attrs %{code: "some code", cutoff: "2010-04-17T14:00:00Z", distance: 120.5, name: "some name"}
    @update_attrs %{code: "some updated code", cutoff: "2011-05-18T15:01:01Z", distance: 456.7, name: "some updated name"}
    @invalid_attrs %{code: nil, cutoff: nil, distance: nil, name: nil}

    def checkpoint_fixture(attrs \\ %{}) do
      {:ok, checkpoint} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SMSRace.create_checkpoint()

      checkpoint
    end

    test "list_checkpoints/0 returns all checkpoints" do
      checkpoint = checkpoint_fixture()
      assert SMSRace.list_checkpoints() == [checkpoint]
    end

    test "get_checkpoint!/1 returns the checkpoint with given id" do
      checkpoint = checkpoint_fixture()
      assert SMSRace.get_checkpoint!(checkpoint.id) == checkpoint
    end

    test "create_checkpoint/1 with valid data creates a checkpoint" do
      assert {:ok, %Checkpoint{} = checkpoint} = SMSRace.create_checkpoint(@valid_attrs)
      assert checkpoint.code == "some code"
      assert checkpoint.cutoff == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert checkpoint.distance == 120.5
      assert checkpoint.name == "some name"
    end

    test "create_checkpoint/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SMSRace.create_checkpoint(@invalid_attrs)
    end

    test "update_checkpoint/2 with valid data updates the checkpoint" do
      checkpoint = checkpoint_fixture()
      assert {:ok, %Checkpoint{} = checkpoint} = SMSRace.update_checkpoint(checkpoint, @update_attrs)
      assert checkpoint.code == "some updated code"
      assert checkpoint.cutoff == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert checkpoint.distance == 456.7
      assert checkpoint.name == "some updated name"
    end

    test "update_checkpoint/2 with invalid data returns error changeset" do
      checkpoint = checkpoint_fixture()
      assert {:error, %Ecto.Changeset{}} = SMSRace.update_checkpoint(checkpoint, @invalid_attrs)
      assert checkpoint == SMSRace.get_checkpoint!(checkpoint.id)
    end

    test "delete_checkpoint/1 deletes the checkpoint" do
      checkpoint = checkpoint_fixture()
      assert {:ok, %Checkpoint{}} = SMSRace.delete_checkpoint(checkpoint)
      assert_raise Ecto.NoResultsError, fn -> SMSRace.get_checkpoint!(checkpoint.id) end
    end

    test "change_checkpoint/1 returns a checkpoint changeset" do
      checkpoint = checkpoint_fixture()
      assert %Ecto.Changeset{} = SMSRace.change_checkpoint(checkpoint)
    end
  end

  describe "passages" do
    alias Smsrace.SMSRace.Passage

    @valid_attrs %{at: "2010-04-17T14:00:00Z"}
    @update_attrs %{at: "2011-05-18T15:01:01Z"}
    @invalid_attrs %{at: nil}

    def passage_fixture(attrs \\ %{}) do
      {:ok, passage} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SMSRace.create_passage()

      passage
    end

    test "list_passages/0 returns all passages" do
      passage = passage_fixture()
      assert SMSRace.list_passages() == [passage]
    end

    test "get_passage!/1 returns the passage with given id" do
      passage = passage_fixture()
      assert SMSRace.get_passage!(passage.id) == passage
    end

    test "create_passage/1 with valid data creates a passage" do
      assert {:ok, %Passage{} = passage} = SMSRace.create_passage(@valid_attrs)
      assert passage.at == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
    end

    test "create_passage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SMSRace.create_passage(@invalid_attrs)
    end

    test "update_passage/2 with valid data updates the passage" do
      passage = passage_fixture()
      assert {:ok, %Passage{} = passage} = SMSRace.update_passage(passage, @update_attrs)
      assert passage.at == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
    end

    test "update_passage/2 with invalid data returns error changeset" do
      passage = passage_fixture()
      assert {:error, %Ecto.Changeset{}} = SMSRace.update_passage(passage, @invalid_attrs)
      assert passage == SMSRace.get_passage!(passage.id)
    end

    test "delete_passage/1 deletes the passage" do
      passage = passage_fixture()
      assert {:ok, %Passage{}} = SMSRace.delete_passage(passage)
      assert_raise Ecto.NoResultsError, fn -> SMSRace.get_passage!(passage.id) end
    end

    test "change_passage/1 returns a passage changeset" do
      passage = passage_fixture()
      assert %Ecto.Changeset{} = SMSRace.change_passage(passage)
    end
  end

  describe "messages" do
    alias Smsrace.SMSRace.Message

    @valid_attrs %{created: "2010-04-17T14:00:00Z", direction: "some direction", from: "some from", id: "some id", message: "some message", to: "some to"}
    @update_attrs %{created: "2011-05-18T15:01:01Z", direction: "some updated direction", from: "some updated from", id: "some updated id", message: "some updated message", to: "some updated to"}
    @invalid_attrs %{created: nil, direction: nil, from: nil, id: nil, message: nil, to: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SMSRace.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert SMSRace.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert SMSRace.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = SMSRace.create_message(@valid_attrs)
      assert message.created == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert message.direction == "some direction"
      assert message.from == "some from"
      assert message.id == "some id"
      assert message.message == "some message"
      assert message.to == "some to"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SMSRace.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = SMSRace.update_message(message, @update_attrs)
      assert message.created == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert message.direction == "some updated direction"
      assert message.from == "some updated from"
      assert message.id == "some updated id"
      assert message.message == "some updated message"
      assert message.to == "some updated to"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = SMSRace.update_message(message, @invalid_attrs)
      assert message == SMSRace.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = SMSRace.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> SMSRace.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = SMSRace.change_message(message)
    end
  end
end
