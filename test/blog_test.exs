defmodule BlogTest do
  use ExUnit.Case

  alias Blog.Repo
  alias Blog.User
  alias Blog.Post

  import Ecto.Query

  setup_all do
    {:ok, pid} = Blog.start(nil, nil)
    {:ok, [pid: pid]}
  end

  test "that everything works as it should" do
    # assert we can insert and query a user
    {:ok, author} = %User{name: "ludwig_wittgenstein", email: "sharp_witt@example.de"} |> Repo.insert
    ["ludwig_wittgenstein"] = User |> select([user], user.name) |> Repo.all

    # assert we can insert posts
    Repo.insert(%Post{user_id: author.id, title: "Tractatus", body: "Nothing to say."})
    Repo.insert(%Post{user_id: author.id, title: "Tractatus", body: "Nothing else to say."})
    Repo.insert(%Post{user_id: author.id, title: "Tractatus", body: "Nothing more to say."})
    assert List.duplicate("Tractatus", 3) == Post
                                             |> select([post], post.title)
                                             |> where([post], post.user_id == ^author.id)
                                             |> Repo.all

    # ... and one more post and user for good measure
    {:ok, user} = %User{name: "john_cusack", email: "cusack66@example.com"} |> Repo.insert
    Repo.insert(%Post{user_id: user.id, title: "Trashy 80's Romance", body: "Say anything."})
    assert ["Trashy 80's Romance"] == Post
                                      |> select([post], post.title)
                                      |> where([post], post.user_id == ^user.id)
                                      |> Repo.all
  end
end