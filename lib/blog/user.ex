defmodule Blog.User do
  use Ecto.Model
  alias Blog.Post

  schema "users" do
    has_many :posts, Post
    field :name, :string
    field :email, :string
    timestamps()
  end
end