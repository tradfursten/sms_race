defmodule SmsraceWeb.RaceLive do
  use SmsraceWeb, :live_view

  @impl true
  def mount(%{"id" => race_id}, session, socket) do

    race = Smsrace.SMSRace.get_race_with_checkpoints_and_participants!(race_id)

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

    checkpoints = race.checkpoints
    |> Enum.filter(fn c -> Enum.member?(["start", "checkpoint", "finish"], c.type) end)
    |> Enum.sort(fn c1, c2 -> c1.number <= c2.number end)

    participants = race.participants


    socket = socket
    |> assign(race: race, owns_race: owns_race, checkpoints: checkpoints, participants: participants)
    {:ok, socket}

  end

  @impl true
  def handle_event("start-race", %{"start-at" => start_at}, socket) do
    at = start_at
    |> fn n -> n <> ":00" end.()
    |> NaiveDateTime.from_iso8601!()
    |> DateTime.from_naive!(socket.assigns.race.timezone)
    |> DateTime.shift_zone!("Etc/UTC")
    Smsrace.SMSRace.start_race(socket.assigns.race.id, at);
    {:noreply, socket}
  end

  @impl true
  def handle_event("start-race", test, socket) do
    IO.inspect(test)
    at = test["start_at"]
    |> fn n -> n <> ":00" end.()
    |> NaiveDateTime.from_iso8601!()
    |> DateTime.from_naive!(socket.assigns.race.timezone)
    |> DateTime.shift_zone!("Etc/UTC")
    Smsrace.SMSRace.start_race(socket.assigns.race.id, at);
    {:noreply, socket}
  end
end
