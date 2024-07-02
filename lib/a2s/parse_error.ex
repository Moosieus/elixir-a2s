defmodule A2S.ParseError do
  @moduledoc """
  Struct representing an error encountered in parsing an A2S response.
  """

  # Internal Notes:
  # This is basically a log that says more than just (MatchError) to be repl'd
  # later. Can't do much to remediate invalid data and more defensive errors
  # could mislead here.

  defexception response_type: nil, data: <<>>, exception: nil

  def message(%__MODULE__{response_type: rt}) do
    "Invalid data in #{rt} response"
  end

  @type t :: %A2S.ParseError{
          response_type: atom() | nil,
          data: binary()
        }
end
