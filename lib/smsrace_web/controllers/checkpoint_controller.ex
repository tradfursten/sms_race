defmodule SmsraceWeb.CheckpointController do
  use SmsraceWeb, :controller

  alias Smsrace.SMSRace
  alias Smsrace.SMSRace.Checkpoint

  def index(conn, _params) do
    checkpoints = SMSRace.list_checkpoints_with_race()
    render(conn, "index.html", checkpoints: checkpoints)
  end

  def new(conn, _params) do
    changeset = SMSRace.change_checkpoint(%Checkpoint{})
    races = SMSRace.list_races()
    |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, races: races)
  end

  def create(conn, %{"checkpoint" => checkpoint_params}) do
    case SMSRace.create_checkpoint(checkpoint_params) do
      {:ok, checkpoint} ->
        conn
        |> put_flash(:info, "Checkpoint created successfully.")
        |> redirect(to: Routes.checkpoint_path(conn, :show, checkpoint))

      {:error, %Ecto.Changeset{} = changeset} ->
        races = SMSRace.list_races()
        |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset, races: races)
    end
  end

  def show(conn, %{"id" => id}) do
    checkpoint = SMSRace.get_checkpoint!(id)
    render(conn, "show.html", checkpoint: checkpoint)
  end

  def edit(conn, %{"id" => id}) do
    checkpoint = SMSRace.get_checkpoint!(id)
    changeset = SMSRace.change_checkpoint(checkpoint)
    races = SMSRace.list_races()
    |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", checkpoint: checkpoint, changeset: changeset, races: races)
  end

  def update(conn, %{"id" => id, "checkpoint" => checkpoint_params}) do
    checkpoint = SMSRace.get_checkpoint!(id)

    case SMSRace.update_checkpoint(checkpoint, checkpoint_params) do
      {:ok, checkpoint} ->
        conn
        |> put_flash(:info, "Checkpoint updated successfully.")
        |> redirect(to: Routes.checkpoint_path(conn, :show, checkpoint))

      {:error, %Ecto.Changeset{} = changeset} ->
        races = SMSRace.list_races()
        |> Enum.map(&{&1.name, &1.id})
        render(conn, "edit.html", checkpoint: checkpoint, changeset: changeset, races: races)
    end
  end

  def delete(conn, %{"id" => id}) do
    checkpoint = SMSRace.get_checkpoint!(id)
    {:ok, _checkpoint} = SMSRace.delete_checkpoint(checkpoint)

    conn
    |> put_flash(:info, "Checkpoint deleted successfully.")
    |> redirect(to: Routes.checkpoint_path(conn, :index))
  end
end
