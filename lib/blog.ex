defmodule Blog do
  @moduledoc """
  Documentation for Blog.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Blog.Repo, [])
    ]
    opts = [strategy: :one_for_one, name: Blog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
