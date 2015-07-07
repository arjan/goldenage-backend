-module(service_goldenage_userinfo).
-svc_needauth(true).

-export([process_get/2, info/2]).

-include_lib("zotonic.hrl").


process_get(_, Context) ->
    info(Context#context.user_id, Context).

info(UserId, Context) ->
    ga_util:rsc_json(UserId, [title, email, image, {edges, likes}, {edges, read}], Context).


