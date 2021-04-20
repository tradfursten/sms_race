defmodule SmsraceWeb.ParticipantLive do
  use SmsraceWeb, :live_view

  def mount(%{"id" => participant_id}, _session, socket) do

    participant = Smsrace.SMSRace.get_participant_with_passages!(participant_id)

    {:ok, assign(socket, participant: participant)}

  end

end
