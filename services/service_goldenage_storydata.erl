-module(service_goldenage_storydata).

-export([process_get/2]).

process_get(_, Context) ->
    Id = m_rsc:name_to_id_check(z_context:get_q("id", Context), Context),
    {name, N} = proplists:lookup(name, m_rsc:p(Id, category, Context)),
    <<"story">> = z_convert:to_binary(N),
    
    {struct, StoryInfo} = ga_util:rsc_json(Id, [title, summary, publication_start, image], Context),

    {struct,
     [{chapters,
       {array, [chapter_info(ChId, Context) || ChId <- m_edge:objects(Id, has_chapter, Context)]}}
      | StoryInfo
     ]}.


%% chapters

chapter_info(Id, Context) ->
    {struct, P} = ga_util:rsc_json(Id, [title], Context),
    Cards = lists:sort(
              fun({struct, A}, {struct, B}) ->
                      proplists:get_value(time, A) < proplists:get_value(time, B)
              end,
              [card_info(ZId, Context) || ZId <- m_edge:objects(Id, has_card, Context)]
             ),
    
    {struct,
     [
      {zones,
       {array, [zone_info(ZId, Context) || ZId <- m_edge:objects(Id, has_zone, Context)]}},
      {cards,
       {array, Cards}}
      | P
     ]}.
              
%% zones + beacons


zone_info(Id, Context) ->
    {struct, P} = ga_util:rsc_json(Id, [title], Context),
    {struct,
     [
      {beacons,
       {array, [beacon_info(BId, Context) || BId <- m_edge:objects(Id, has_beacon, Context)]}}
      | P
      ]}.


beacon_info(Id, Context) ->
    ga_util:rsc_json(Id, [title, uuid, major, minor], Context).


card_info(Id, Context) ->
    ga_util:rsc_json(Id, [title, summary, body, image, time, {person, author}, {person, target}], Context).
