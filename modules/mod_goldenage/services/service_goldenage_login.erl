-module(service_goldenage_login).

-export([process_post/2]).

-include_lib("zotonic.hrl").

process_post(_, Context) ->
    Email = z_context:get_q("email", Context),
    Name = z_context:get_q("name", Context),

    lager:warning("Signup: ~p ~p", [Name, Email]),
    
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

    case z_context:get_q("avatar", Context) of
        undefined -> nop;
        #upload{}=Upload ->
            case m_media:insert_file(Upload, [], SudoContext) of
                {ok, Id} ->
                    m_edge:replace(UID, depiction, [Id], SudoContext);
                _=E ->
                    lager:error("Upload error: ~p", [E])
            end
    end,
    
    service_goldenage_userinfo:info(UID, Context).

