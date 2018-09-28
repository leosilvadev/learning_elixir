defmodule Todo.Item do

  alias Todo.Item

  defstruct [
    id: nil,
    date: nil,
    title: nil,
    description: nil
  ]

  def new(title, description, date), do:
    %Item{title: title, description: description, date: date}

end
