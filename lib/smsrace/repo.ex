defmodule Smsrace.Repo do
  use Ecto.Repo,
    otp_app: :smsrace,
    adapter: Ecto.Adapters.Postgres
end
