-module(service_goldenage_read).
-svc_needauth(true).

-export([process_post/2]).

-include_lib("zotonic.hrl").

process_post(_, Context) ->
    CardId = z_convert:to_integer(z_context:get_q("card_id", Context)),
    Delete = z_convert:to_bool(z_context:get_q("delete", Context)),

    SudoContext = z_acl:sudo(Context),

    lager:info("service_goldenage_read: user=~p, card_id=~p delete=~p", [Context#context.user_id, CardId, Delete]),
    
    case Delete of
        false ->
            %% add edge
            m_edge:insert(Context#context.user_id, read, CardId, SudoContext);
        true ->
            %% delete it
            m_edge:delete(Context#context.user_id, read, CardId, SudoContext)
    end,
    {struct, []}.
