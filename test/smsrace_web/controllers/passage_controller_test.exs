defmodule SmsraceWeb.PassageControllerTest do
  use SmsraceWeb.ConnCase

  alias Smsrace.SMSRace

  @create_attrs %{at: "2010-04-17T14:00:00Z"}
  @update_attrs %{at: "2011-05-18T15:01:01Z"}
  @invalid_attrs %{at: nil}

  def fixture(:passage) do
    {:ok, passage} = SMSRace.create_passage(@create_attrs)
    passage
  end

  describe "index" do
    test "lists all passages", %{conn: conn} do
      conn = get(conn, Routes.passage_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Passages"
    end
  end

  describe "new passage" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.passage_path(conn, :new))
      assert html_response(conn, 200) =~ "New Passage"
    end
  end

  describe "create passage" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.passage_path(conn, :create), passage: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.passage_path(conn, :show, id)

      conn = get(conn, Routes.passage_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Passage"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.passage_path(conn, :create), passage: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Passage"
    end
  end

  describe "edit passage" do
    setup [:create_passage]

    test "renders form for editing chosen passage", %{conn: conn, passage: passage} do
      conn = get(conn, Routes.passage_path(conn, :edit, passage))
      assert html_response(conn, 200) =~ "Edit Passage"
    end
  end

  describe "update passage" do
    setup [:create_passage]

    test "redirects when data is valid", %{conn: conn, passage: passage} do
      conn = put(conn, Routes.passage_path(conn, :update, passage), passage: @update_attrs)
      assert redirected_to(conn) == Routes.passage_path(conn, :show, passage)

      conn = get(conn, Routes.passage_path(conn, :show, passage))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, passage: passage} do
      conn = put(conn, Routes.passage_path(conn, :update, passage), passage: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Passage"
    end
  end

  describe "delete passage" do
    setup [:create_passage]

    test "deletes chosen passage", %{conn: conn, passage: passage} do
      conn = delete(conn, Routes.passage_path(conn, :delete, passage))
      assert redirected_to(conn) == Routes.passage_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.passage_path(conn, :show, passage))
      end
    end
  end

  defp create_passage(_) do
    passage = fixture(:passage)
    %{passage: passage}
  end
end
