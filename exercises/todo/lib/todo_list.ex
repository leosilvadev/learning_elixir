defmodule Todo.List do

  alias Todo.Item
  alias Todo.List

  @moduledoc """
  Documentation for Todo.
  """
  defstruct auto_id: 1, entries: %{}

  def new(), do: %List{}

  def add_entry(%List{auto_id: auto_id, entries: entries} = todo_list, %Item{} = item) do
    entry = Map.put(item, :id, auto_id)
    %List{
      todo_list |
      auto_id: auto_id + 1,
      entries: Map.put(entries, auto_id, entry)
    }
  end
end
