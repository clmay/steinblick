defmodule Steinblick.Repo do
  use Ecto.Repo,
    otp_app: :steinblick,
    adapter: Ecto.Adapters.SQLite3
end
