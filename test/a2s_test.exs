defmodule A2STest do
  @moduledoc """
  Foregoing tests at the time of writing - Focusing on battle-testing with real world apps and improving docs.

  Desirable testing includes:
  - Unit testing for `A2S` against real-world data
  - Mocking game servers for `A2S.Client`

  Ideally unit test data's stored as `list(TestData)`, and serialized to a file via `:erlang.binary_to_term`.
  """

  use ExUnit.Case
  doctest A2S

  defmodule TestCase do
    defstruct [
      :server_name, :game, :data, :func, :expected, :date_collected, :note
    ]

    @type t :: %TestData{
      server_name: String.t,
      game: String.t,
      data: binary,
      func: function(),
      expected: any,
      date_collected: any,
      note: String.t
    }
  end
end
