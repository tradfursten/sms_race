defmodule SmsraceWeb.RaceLive do
  use SmsraceWeb, :live_view

  def mount(%{"id" => race_id}, _session, socket) do

    race = Smsrace.SMSRace.get_race_with_participants!(race_id)

    {:ok, assign(socket, race: race)}

  end

end
