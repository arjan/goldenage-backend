-module(service_goldenage_personcards).
-svc_needauth(true).

-export([process_get/2]).

-include_lib("zotonic.hrl").


process_get(_, Context) ->
    Id = m_rsc:name_to_id_check(z_context:get_q("id", Context), Context),
    {name, N} = proplists:lookup(name, m_rsc:p(Id, category, Context)),
    case z_convert:to_binary(N) of
        <<"historical_person">> -> ok;
        P -> throw({error, not_a_person, z_convert:to_atom(P)})
    end,

    %% collect all cards of this person that have been seen by this user.
    Seen = m_edge:objects(Context#context.user_id, cardseen, Context),

    AllPersonCards = m_edge:subjects(Id, author, Context) ++ m_edge:subjects(Id, target, Context),

    PersonCards = sets:to_list(sets:intersection(sets:from_list(Seen), sets:from_list(AllPersonCards))),
    ImgOpts = [{width, 600}],

    {struct,
     [
      {cards, {array,
               [
                service_goldenage_storydata:card_info(C, Context) ||
                   C <- PersonCards]}},
      {persons,
       service_goldenage_storydata:get_persons_for_card_ids(PersonCards, ImgOpts, Context)}

     ]}.


