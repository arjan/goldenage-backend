-module(service_goldenage_favorites).
-svc_needauth(true).

-export([process_get/2]).

-include_lib("zotonic.hrl").

process_get(_, Context) ->
    CardIds = lists:reverse(m_edge:objects(Context#context.user_id, likes, Context)),
    {struct,
     [{cards, {array, [service_goldenage_storydata:card_info(C, Context) || C <- CardIds]}}]
     ++ service_goldenage_storydata:get_persons_for_card_ids(CardIds, [{width, 600}], Context)
    }.
