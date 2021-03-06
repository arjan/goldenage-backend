-module(service_goldenage_storydata).

-export([process_get/2]).

-export([get_persons_for_card_ids/3, card_info/2]).


process_get(_, Context) ->
    Id = m_rsc:name_to_id_check(z_context:get_q("id", Context), Context),
    {name, N} = proplists:lookup(name, m_rsc:p(Id, category, Context)),
    case z_convert:to_binary(N) of
        <<"story">> -> ok;
        P -> throw({error, not_a_story, z_convert:to_atom(P)})
    end,

    {struct, StoryInfo} = ga_util:rsc_json(Id, [title, subtitle, summary, publication_start, thumbnail, lang, image, {edges, network}], Context),
    ImgOpts = [{width, 600}],

    {
      {struct,
       [{chapters,
         {array, [chapter_info(ChId, Context) || ChId <- m_edge:objects(Id, has_chapter, Context)]}}        
        | StoryInfo]
       ++ collect_extra_person_info(Id, ImgOpts, Context)
      },
      z_context:set_resp_header("Cache-Control", "max-age=3600", Context)
    }.      


%% chapters

chapter_info(Id, Context) ->
    {struct, P} = ga_util:rsc_json(Id, [title], Context),
    Cards = [card_info(ZId, Context) || ZId <- m_edge:objects(Id, has_card, Context)],

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

%% card

card_info(Id, Context) ->
    ga_util:rsc_json(Id, [title, summary, summary2, image, images, card_date, hashtags, time, {edge, author}, {edge, target}, {edges, likes}], Context).


collect_extra_person_info(StoryId, ImgOpts, Context) ->
    ChapterIds = m_edge:objects(StoryId, has_chapter, Context),
    CardIds =  lists:flatten(
                 [m_edge:objects(ChId, has_card, Context) ||  ChId <- ChapterIds]),
    ExtraPersons = m_edge:objects(StoryId, network, Context),
    get_persons_for_card_ids(CardIds, ImgOpts, ExtraPersons, Context).


get_persons_for_card_ids(CardIds, ImgOpts, Context) ->
    get_persons_for_card_ids(CardIds, ImgOpts, [], Context).

get_persons_for_card_ids(CardIds, ImgOpts, ExtraPersons, Context) ->
    AllIds = sets:to_list(
                  sets:from_list(
                    lists:flatten(
                      [
                       [m_edge:objects(CardId, P, Context)
                        || P <- [author, target, likes]]
                       || CardId <- CardIds])
                    ++ ExtraPersons
                   )
                 ),
    {GroupIds, PersonIds} =
        lists:partition(fun(I) -> m_rsc:is_a(I, group, Context) end, AllIds),
 
    HashtagIds = sets:to_list(
                  sets:from_list(
                    lists:flatten(
                      [m_edge:objects(CardId, has_hashtag, Context) || CardId <- CardIds])
                   )
                 ),

    
    [
     {persons, 
      {struct,
     [{P, ga_util:rsc_json(P, [title, subtitle, summary, image, keyvalue], ImgOpts, Context)}
      || P <- PersonIds]}},
     {groups,
      {struct,
       [{P, ga_util:rsc_json(P, [title, subtitle, summary, image, {subject_edges, has_group, members}], ImgOpts, Context)}
        || P <- GroupIds]}},

     {hashtags,
      {struct,
       [{H, ga_util:rsc_json(H, [title, summary, image], ImgOpts, Context)} || H <- HashtagIds]}}
     
    ].
