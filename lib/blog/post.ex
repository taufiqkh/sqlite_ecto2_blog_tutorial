defmodule Blog.Post do
  use Ecto.Schema
  alias Blog.User

  schema "posts" do
    belongs_to :user, User
    field :title, :string
    field :body, :string
    timestamps()
  end
end