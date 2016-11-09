defmodule Elasticsearch.Schema do
  @doc false
  defmacro __using__(_opts) do
    quote do
      use Elasticsearch.Schema.{Mapping, Analysis}
    end
  end

  alias Elasticsearch.API.Indices.Actions

  def create_index(st, opts \\ [])
  def create_index(%{} = st, opts), do: create_index st.__struct__, opts
  def create_index(model, opts) do
    target_index = opts.delete(:index) || self.index_name

    # delete_index!(opts.merge index: target_index) if opts[:force]

    # unless index_exists?(index: target_index) do
      # self.client.indices.create index: target_index,
                                 # body: %{
                                   # settings: self.settings.to_hash,
                                   # mappings: self.mappings.to_hash,
                                 # }
    # end

    body = %{
      mappings: %{something: model.__es_mapping__(:to_map)}
    }
    body = Map.merge body, (if model.module_info(:functions)[:__es_analysis__] do
      %{settings: model.__es_analysis__(:to_map),}
    else
      %{}
    end)

    ts = nil
    Actions.create ts, %{
      index: "unko",
      body: body
    }
  end

end
