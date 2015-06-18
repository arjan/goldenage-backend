-module(service_goldenage_stories).

-export([process_get/2]).

process_get(_, Context) ->
    Ids = z_search:query_([{cat, story}, {sort, "-publication_start"}], Context),
    {array, [story_info(Id, Context) || Id <- Ids]}.

story_info(Id, Context) ->
    ga_util:rsc_json(Id, [title, subtitle, summary, publication_start, image], Context).

             
