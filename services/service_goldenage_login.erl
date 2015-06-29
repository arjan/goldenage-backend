-module(service_goldenage_login).

-export([process_post/2]).

-include_lib("zotonic.hrl").

process_post(_, Context) ->
    Email = z_context:get_q("email", Context),
    Name = z_context:get_q("name", Context),

    SudoContext = z_acl:sudo(Context),

    UID = case m_identity:lookup_by_type_and_key(email_only, Email, Context) of
                 undefined ->
                     %% create user
                     {ok, UserId} = m_rsc:insert([{category, profile},
                                                  {is_published, true},
                                                  {title, Name},
                                                  {email, Email}], SudoContext),
                     {ok, _} = m_identity:insert(UserId, email_only, Email, SudoContext),
                     UserId;
                 R ->
                     UserId = proplists:get_value(rsc_id, R),
                     m_rsc:update(UserId, [{title, Name}], SudoContext),
                     UserId
             end,
    service_goldenage_userinfo:info(UID, Context).




