-module(service_goldenage_stories).

-export([process_get/2]).

process_get(_, Context) ->
    Ids = z_search:query_([{cat, story}, {sort, "-publication_start"}], Context),
    {array, [story_info(Id, Context) || Id <- Ids]}.


story_info(Id, Context) ->
    {struct,
     [{id, Id},
      {title, trans(m_rsc:p(Id, title, Context), Context)},
      {summary, trans(m_rsc:p(Id, summary, Context), Context)},
      {publication_start, z_datetime:format(m_rsc:p(Id, publication_start, Context), "c", Context)}
     ]}.

trans(undefined, _) ->
    null;
trans(T, Context) ->
    z_trans:trans(T, Context).
