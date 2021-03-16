defmodule SmsraceWeb.CheckpointControllerTest do
  use SmsraceWeb.ConnCase

  alias Smsrace.SMSRace

  @create_attrs %{code: "some code", cutoff: "2010-04-17T14:00:00Z", distance: 120.5, name: "some name"}
  @update_attrs %{code: "some updated code", cutoff: "2011-05-18T15:01:01Z", distance: 456.7, name: "some updated name"}
  @invalid_attrs %{code: nil, cutoff: nil, distance: nil, name: nil}

  def fixture(:checkpoint) do
    {:ok, checkpoint} = SMSRace.create_checkpoint(@create_attrs)
    checkpoint
  end

  describe "index" do
    test "lists all checkpoints", %{conn: conn} do
      conn = get(conn, Routes.checkpoint_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Checkpoints"
    end
  end

  describe "new checkpoint" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.checkpoint_path(conn, :new))
      assert html_response(conn, 200) =~ "New Checkpoint"
    end
  end

  describe "create checkpoint" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.checkpoint_path(conn, :create), checkpoint: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.checkpoint_path(conn, :show, id)

      conn = get(conn, Routes.checkpoint_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Checkpoint"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.checkpoint_path(conn, :create), checkpoint: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Checkpoint"
    end
  end

  describe "edit checkpoint" do
    setup [:create_checkpoint]

    test "renders form for editing chosen checkpoint", %{conn: conn, checkpoint: checkpoint} do
      conn = get(conn, Routes.checkpoint_path(conn, :edit, checkpoint))
      assert html_response(conn, 200) =~ "Edit Checkpoint"
    end
  end

  describe "update checkpoint" do
    setup [:create_checkpoint]

    test "redirects when data is valid", %{conn: conn, checkpoint: checkpoint} do
      conn = put(conn, Routes.checkpoint_path(conn, :update, checkpoint), checkpoint: @update_attrs)
      assert redirected_to(conn) == Routes.checkpoint_path(conn, :show, checkpoint)

      conn = get(conn, Routes.checkpoint_path(conn, :show, checkpoint))
      assert html_response(conn, 200) =~ "some updated code"
    end

    test "renders errors when data is invalid", %{conn: conn, checkpoint: checkpoint} do
      conn = put(conn, Routes.checkpoint_path(conn, :update, checkpoint), checkpoint: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Checkpoint"
    end
  end

  describe "delete checkpoint" do
    setup [:create_checkpoint]

    test "deletes chosen checkpoint", %{conn: conn, checkpoint: checkpoint} do
      conn = delete(conn, Routes.checkpoint_path(conn, :delete, checkpoint))
      assert redirected_to(conn) == Routes.checkpoint_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.checkpoint_path(conn, :show, checkpoint))
      end
    end
  end

  defp create_checkpoint(_) do
    checkpoint = fixture(:checkpoint)
    %{checkpoint: checkpoint}
  end
end
