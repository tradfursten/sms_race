defmodule SmsraceWeb.RaceControllerTest do
  use SmsraceWeb.ConnCase

  alias Smsrace.SMSRace

  @create_attrs %{name: "some name", start: "2010-04-17T14:00:00Z"}
  @update_attrs %{name: "some updated name", start: "2011-05-18T15:01:01Z"}
  @invalid_attrs %{name: nil, start: nil}

  def fixture(:race) do
    {:ok, race} = SMSRace.create_race(@create_attrs)
    race
  end

  describe "index" do
    test "lists all races", %{conn: conn} do
      conn = get(conn, Routes.race_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Races"
    end
  end

  describe "new race" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.race_path(conn, :new))
      assert html_response(conn, 200) =~ "New Race"
    end
  end

  describe "create race" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.race_path(conn, :create), race: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.race_path(conn, :show, id)

      conn = get(conn, Routes.race_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Race"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.race_path(conn, :create), race: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Race"
    end
  end

  describe "edit race" do
    setup [:create_race]

    test "renders form for editing chosen race", %{conn: conn, race: race} do
      conn = get(conn, Routes.race_path(conn, :edit, race))
      assert html_response(conn, 200) =~ "Edit Race"
    end
  end

  describe "update race" do
    setup [:create_race]

    test "redirects when data is valid", %{conn: conn, race: race} do
      conn = put(conn, Routes.race_path(conn, :update, race), race: @update_attrs)
      assert redirected_to(conn) == Routes.race_path(conn, :show, race)

      conn = get(conn, Routes.race_path(conn, :show, race))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, race: race} do
      conn = put(conn, Routes.race_path(conn, :update, race), race: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Race"
    end
  end

  describe "delete race" do
    setup [:create_race]

    test "deletes chosen race", %{conn: conn, race: race} do
      conn = delete(conn, Routes.race_path(conn, :delete, race))
      assert redirected_to(conn) == Routes.race_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.race_path(conn, :show, race))
      end
    end
  end

  defp create_race(_) do
    race = fixture(:race)
    %{race: race}
  end
end
