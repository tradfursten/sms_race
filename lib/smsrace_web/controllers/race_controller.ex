defmodule SmsraceWeb.RaceController do
  use SmsraceWeb, :controller

  alias Smsrace.SMSRace
  alias Smsrace.SMSRace.Race

  def index(conn, _params) do
    user = conn.assigns.current_user
    races = SMSRace.list_races(user.organization_id)

    render(conn, "index.html", races: races)
  end

  def new(conn, _params) do
    changeset = SMSRace.change_race(%Race{})
    |> Ecto.Changeset.put_change(:timezone, "Europe/Stockholm" )
    |> Ecto.Changeset.put_change(:display_time, DateTime.now!("Europe/Stockholm") |> DateTime.to_naive)

    IO.inspect(changeset)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"race" => race_params}) do
    user = conn.assigns.current_user
    race_params = Map.put(race_params, "organization_id", user.organization_id)
    case SMSRace.create_race(race_params) do
      {:ok, race} ->
        conn
        |> put_flash(:info, "Race created successfully.")
        |> redirect(to: Routes.race_path(conn, :show, race))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    race = SMSRace.get_race!(id, user.organization_id)
    race = race |> Map.put(:display_time, race.start |> DateTime.shift_zone!(race.timezone) |> DateTime.to_naive)
    render(conn, "show.html", race: race)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    race = SMSRace.get_race!(id, user.organization_id)

    changeset = SMSRace.change_race(race)
    |> Ecto.Changeset.put_change(:display_time, race.start |> DateTime.shift_zone!(race.timezone) |> DateTime.to_naive)

    render(conn, "edit.html", race: race, changeset: changeset)
  end

  def update(conn, %{"id" => id, "race" => race_params}) do
    user = conn.assigns.current_user
    race = SMSRace.get_race!(id, user.organization_id)

    race_params = Map.put(race_params, "organization_id", user.organization_id)
    case SMSRace.update_race(race, race_params) do
      {:ok, race} ->
        conn
        |> put_flash(:info, "Race updated successfully.")
        |> redirect(to: Routes.race_path(conn, :show, race))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", race: race, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    race = SMSRace.get_race!(id, user.organization_id)
    {:ok, _race} = SMSRace.delete_race(race)

    conn
    |> put_flash(:info, "Race deleted successfully.")
    |> redirect(to: Routes.race_path(conn, :index))
  end
end
