defmodule SmsraceWeb.RaceLive do
  use SmsraceWeb, :live_view

  def mount(%{"id" => race_id}, session, socket) do

    race = Smsrace.SMSRace.get_race_with_participants!(race_id)

    owns_race = case connected?(socket) do
      true ->
        case is_nil(session["user_token"]) do
          false ->
            user = Smsrace.Accounts.get_user_by_session_token(session["user_token"])
            r_orgid = race.organization_id
            case user.organization_id do
              ^r_orgid -> true
              _ -> false
            end
          true -> false
        end
      false -> false
    end




    socket = socket
    |> assign(race: race, owns_race: owns_race)
    {:ok, socket}

  end

  @impl true
  def handle_event("start-race", %{"started-at" => started_at}, socket) do
    Smsrace.SMSRace.start_race(socket.assigns.race.id, started_at);
    {:noreply, socket}
  end

end
