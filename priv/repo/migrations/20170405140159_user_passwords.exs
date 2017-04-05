defmodule Blog.Repo.Migrations.UserPasswords do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password, :string, [default: "CHANGE_ME", null: false]
    end
  end
end