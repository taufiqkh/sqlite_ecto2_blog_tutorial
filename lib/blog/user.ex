defmodule Blog.User do
  use Ecto.Schema
  alias Blog.Post

  schema "users" do
    has_many :posts, Post
    field :name, :string
    field :email, :string
    field :password, :string, [default: "CHANGE_ME", null: false]
    timestamps()
  end
end