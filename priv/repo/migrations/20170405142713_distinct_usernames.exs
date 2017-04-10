defmodule Blog.Repo.Migrations.DistinctUsernames do
  use Ecto.Migration

  def change do
    create index(:users, [:name], unique: true)
  end
end
