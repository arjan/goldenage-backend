-module(ga_util).

-export([image/3, trans/2, rsc_json/3, rsc_json/4]).


trans(undefined, _) ->
    null;
trans(T, Context) ->
    case z_utils:is_empty(T) of
        true -> null;
        false ->
            z_trans:trans(T, Context)
    end.

image(Id, Opts, Context) ->
    case z_media_tag:url(Id, [{use_absolute_url, true} | Opts], Context) of
        {ok, Url} -> Url;
        _ -> null
    end.


rsc_json(Id, Fields, Context) ->
    rsc_json(Id, Fields, [{width, 600}], Context).

rsc_json(Id, Fields, ImgOpts, Context) ->
    {struct,
     [
      {id, Id},
      {category, proplists:get_value(name, m_rsc:p(Id, category, Context))}
      |
      [map_rsc_json_field(Id, K, ImgOpts, Context)|| K <- Fields]
    ]}.
      
%% images
map_rsc_json_field(Id, image, ImgOpts, Context) ->
    {image, image(Id, ImgOpts, Context)};

%% dates
map_rsc_json_field(Id, DF, _, Context) when DF =:= publication_start; DF =:= publication_end;
                                                  DF =:= date_start; DF =:= date_end ->
    {DF, z_datetime:format(m_rsc:p(Id, DF, Context), "c", Context)};

%% linked person; get first one
map_rsc_json_field(Id, {person, Pred}, ImgOpts, Context) ->
    case m_edge:objects(Id, Pred, Context) of
        [] -> {Pred, null};
        [P|_] ->
            {Pred, rsc_json(P, [title, summary, image], ImgOpts, Context)}
    end;

map_rsc_json_field(Id, K, _, Context) ->
    {K, trans(m_rsc:p(Id, K, Context), Context)}.
