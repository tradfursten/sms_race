defmodule Smsrace.TopicHelper do

  def subscribe_message(number) do
    Phoenix.PubSub.subscribe(Smsrace.PubSub, "messages:" <> number)
  end

  def subscribe_passage_by_checkpoint(checkpoint) do
    Phoenix.PubSub.subscribe(Smsrace.PubSub, "passages:checkpoint:" <> Integer.to_string(checkpoint))
  end

  def subscribe_passage_by_participant(participant) do
    Phoenix.PubSub.subscribe(Smsrace.PubSub, "passages:participant:" <> Integer.to_string(participant))
  end

  def publish_message(%Smsrace.SMSRace.Message{} = message) do
    Phoenix.PubSub.broadcast!(Smsrace.PubSub, "messages:" <> message.to, {:message_saved, message})
  end

  def publish_passage(%Smsrace.SMSRace.Passage{} = passage) do
    IO.inspect(passage)
    unless is_nil(passage.checkpoint_id) do
      Phoenix.PubSub.broadcast!(Smsrace.PubSub, "passages:checkpoint:" <> Integer.to_string(passage.checkpoint_id), {:passage_saved, passage})
    end
    if is_nil(passage.participant_id) == false do
      Phoenix.PubSub.broadcast!(Smsrace.PubSub, "passages:participant:" <> Integer.to_string(passage.participant_id), {:passage_saved, passage})
    end
  end
end
