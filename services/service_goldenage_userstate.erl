-module(service_goldenage_userstate).
-svc_needauth(true).

-export([process_get/2, process_post/2]).

-include_lib("zotonic.hrl").


process_get(_, Context) ->
    case z_context:get_q("story_id", Context) of
        undefined ->
            {error, missing_arg, "story_id"};
        _ ->
            get_state(Context)
    end.

process_post(_, Context) ->
    case {z_context:get_q("story_id", Context), z_context:get_q("state", Context)} of
        {undefined, _} ->
            {error, missing_arg, "story_id"};
        {_, undefined} ->
            {error, missing_arg, "state"};
        {_, State} ->
            io:format(user, "State: ~p~n", [State]),
            m_tkvstore:put(user_state, key(Context), State, Context),
            get_state(Context)
    end.

get_state(Context) ->
    K = key(Context),
    lager:warning("K: ~p", [K]),
    case m_tkvstore:get(user_state, K, Context) of
        undefined ->
            {struct, []};
        {struct, _}=R ->
            R
    end.

key(Context) ->
    z_convert:to_list(Context#context.user_id)
        ++ "-"
        ++ z_convert:to_list(z_context:get_q("story_id", Context)).

