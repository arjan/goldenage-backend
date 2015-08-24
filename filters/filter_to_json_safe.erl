
-module(filter_to_json_safe).
-export([to_json_safe/2, to_json_safe/3]).

%% @doc Convert an Erlang list or tuple to JSON
%% This function assumes that all strings of the input term are made of utf-8-encoded characters. 
%% @spec to_json(list() | tuple(), #context{}) -> iodata()
to_json(Value, Context) ->
    to_json(Value, "utf-8", Context).

%% @doc Convert an Erlang list or tuple to JSON
%% This function assumes that the all strings of the input term have the same 
%% character encoding. This encoding may be UTF-8 or ISO 8859-1 (also called Latin-1). 
%% @spec to_json(list() | tuple(), string(), #context{}) -> iodata()
to_json(Value, "latin-1", _Context) ->
    mochijson:encode(z_convert:to_json(Value));

to_json(Value, "utf-8", _Context) ->
    try
        Encoder = mochijson:encoder([{input_encoding, utf8}]),
        Encoder(z_convert:to_json(Value)).
    catch _:_ ->
            []
    end.


