defmodule Blog.Repo do
  use Ecto.Repo, otp_app: :blog, adapter: Sqlite.Ecto2
end
