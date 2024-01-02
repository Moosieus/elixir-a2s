defmodule A2S.StateMachineTranslator do
  @moduledoc false
  # https://github.com/Kraigie/nostrum/blob/master/lib/nostrum/state_machine_translator.ex

  def translate(min_level, :error, :report, {:logger, %{label: label} = report}) do
    case label do
      {:gen_statem, :terminate} ->
        report_gen_statem_terminate(min_level, report)

      _ ->
        :none
    end
  end

  def translate(_min_level, _level, _kind, _data) do
    :none
  end

  defp report_gen_statem_terminate(_min_level, report) do
    # raw erlang format. you know it, you love it.
    # thanks to OTP for exposing this in the first place.
    log = :gen_statem.format_log(report, %{})
    {:ok, :erlang.list_to_binary(log), []}
  end
end
