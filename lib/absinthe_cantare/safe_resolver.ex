defmodule AbsintheCantare.SafeResolver do
  def safely(fun) do
    fn parent, args, config ->
      resolver_result =
        case :erlang.fun_info(fun)[:arity] do
          2 -> fun.(args, config)
          3 -> fun.(parent, args, config)
        end

      case resolver_result do
        {:ok, anything} ->
          {:ok, anything}

        {:error, changeset = %{errors: _}} ->
          err =
            changeset
            |> Ecto.Changeset.traverse_errors(fn {msg, opts} ->
              Enum.reduce(opts, msg, fn {key, value}, acc ->
                String.replace(acc, "%{#{key}}", to_string(value))
              end)
            end)
            |> Enum.into(%{}, fn {k, v} -> {k, Enum.join(v, ", ")} end)
            |> Map.to_list()
            |> Enum.map(fn {k, v} -> "#{Phoenix.Naming.humanize(k)} #{v}" end)
            |> Enum.join(", ")

          {:error, err}

        {:error, %{data: %{errors: errors}}} ->
          {:error, errors |> Kernel.inspect()}

        {:error, "" <> str} ->
          {:error, str}

        {:error, anything} ->
          {:error, anything |> Kernel.inspect()}
      end
    end
  end
end
