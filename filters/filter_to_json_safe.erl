-module(filter_to_json_safe).
-export([to_json_safe/2]).

%% @spec to_json_safe(list() | tuple(), #context{}) -> iodata()
to_json_safe(Value, Context) ->
    try
        filter_to_json:to_json(Value, Context)
    catch _:_ ->
            []
    end.
