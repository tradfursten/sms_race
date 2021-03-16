defmodule SmsraceWeb.PassageController do
  use SmsraceWeb, :controller

  alias Smsrace.SMSRace
  alias Smsrace.SMSRace.Passage

  def index(conn, _params) do
    passages = SMSRace.list_passages()
    render(conn, "index.html", passages: passages)
  end

  def new(conn, _params) do
    changeset = SMSRace.change_passage(%Passage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"passage" => passage_params}) do
    case SMSRace.create_passage(passage_params) do
      {:ok, passage} ->
        conn
        |> put_flash(:info, "Passage created successfully.")
        |> redirect(to: Routes.passage_path(conn, :show, passage))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    passage = SMSRace.get_passage!(id)
    render(conn, "show.html", passage: passage)
  end

  def edit(conn, %{"id" => id}) do
    passage = SMSRace.get_passage!(id)
    changeset = SMSRace.change_passage(passage)
    render(conn, "edit.html", passage: passage, changeset: changeset)
  end

  def update(conn, %{"id" => id, "passage" => passage_params}) do
    passage = SMSRace.get_passage!(id)

    case SMSRace.update_passage(passage, passage_params) do
      {:ok, passage} ->
        conn
        |> put_flash(:info, "Passage updated successfully.")
        |> redirect(to: Routes.passage_path(conn, :show, passage))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", passage: passage, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    passage = SMSRace.get_passage!(id)
    {:ok, _passage} = SMSRace.delete_passage(passage)

    conn
    |> put_flash(:info, "Passage deleted successfully.")
    |> redirect(to: Routes.passage_path(conn, :index))
  end
end
