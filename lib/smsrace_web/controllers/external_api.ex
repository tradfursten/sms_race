defmodule SmsraceWeb.ExternalApiController do
  use SmsraceWeb, :controller

  require Logger


  alias Smsrace.SMSRace
  alias Smsrace.SMSRace.Messages

  def create(conn, %{"id" => id} = params) do
    Logger.debug "Var value: #{inspect(params)}"

    %{api_id: params.id, from: params.from}
    conn
    |> send_resp(200, "")
  end

end
