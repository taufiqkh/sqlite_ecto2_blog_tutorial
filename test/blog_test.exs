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

  setup do
    on_exit fn ->
      Repo.delete_all(Post)
      Repo.delete_all(User)
    end
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
    # preload user posts
    query = from u in User, where: u.id == ^author.id, preload: [:posts]
    titles = query
    |> Repo.all
    |> Enum.map(fn user -> user.posts end)
    |> List.flatten
    |> Enum.map(fn post -> post.title end)
    assert List.duplicate("Tractatus", 3) == titles

    # update user password
    passwordChange = Ecto.Changeset.change(%User{id: author.id}, password: "leopoldine")
    Repo.update(passwordChange)
    assert ["leopoldine"] == User
                             |> select([user], user.password)
                             |> where([user], user.id == ^author.id)
                             |> Repo.all

    # prevent usernames from overlapping
    assert_raise Sqlite.Ecto.Error, "constraint: UNIQUE constraint failed: users.name", fn ->
      %User{name: "ludwig_wittgenstein", password: "NOT_THE_REAL_USER"} |> Repo.insert
    end

  end
end