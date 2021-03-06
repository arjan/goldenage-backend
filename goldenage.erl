%% @author Arjan Scherpenisse
%% @copyright 2015 Arjan Scherpenisse
%% Generated on 2015-05-26
%% @doc This site was based on the 'empty' skeleton.

%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%%     http://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(goldenage).
-author("Arjan Scherpenisse").

-mod_title("goldenage zotonic site").
-mod_description("An empty Zotonic site, to base your site on.").
-mod_prio(10).
-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
         manage_schema/2,
         observe_acl_is_allowed/2,
         observe_rsc_update/3,
         observe_service_authorize/2
        ]).

%%====================================================================
%% support functions go here
%%====================================================================

observe_acl_is_allowed(#acl_is_allowed{object=#acl_edge{subject_id=U}}, Context) ->
    UserId = z_acl:user(Context),
    U =:= UserId orelse m_rsc:p(U, creator_id, Context) =:= UserId;
observe_acl_is_allowed(#acl_is_allowed{action=insert, object=#acl_rsc{category=image}}, _Context) ->
    true;
observe_acl_is_allowed(#acl_is_allowed{action=insert, object=#acl_media{}}, _Context) ->
    true;
observe_acl_is_allowed(What, _C) ->
    undefined.

manage_schema(install, _Context) ->
    #datamodel{
       resources=[
                  {page_credits,
                   text,
                   [{title, <<"Credits">>},
                    {page_path, <<"/app/credits">>}]},
                  {page_help,
                   text,
                   [{title, <<"Help">>},
                    {page_path, <<"/app/help">>}]}
                 ],
       categories=[
                   {goldenage,
                    undefined,
                    [{title, <<"Golden Age">>}, {feature_show_address, false}]},
                   {story,
                    goldenage,
                    [{title, <<"Story">>}, {feature_show_address, false}]},
                   {chapter,
                    goldenage,
                    [{title, <<"Chapter">>}, {feature_show_address, false}]},
                   {zone,
                    goldenage,
                    [{title, <<"Zone">>}, {feature_show_address, false}]},
                   {beacon,
                    goldenage,
                    [{title, <<"Beacon">>}, {feature_show_address, false}]},
                   {card,
                    goldenage,
                    [{title, <<"Card">>}, {feature_show_address, false}]},
                   {group,
                    goldenage,
                    [{title, <<"Person group">>}, {feature_show_address, false}]},
                   {hashtag,
                    goldenage,
                    [{title, <<"Hashtag">>}, {feature_show_address, false}]},

                   {historical_person,
                    person,
                    [{title, <<"Historical person">>}, {feature_show_address, false}]},

                   {profile,
                    person,
                    [{title, <<"Profile">>}, {feature_show_address, false}]},

                   {checkin, card, [{title, <<"Card - Checkin">>}, {feature_show_address, false}]},
                   {friend_request, card, [{title, <<"Card - Friend request">>}, {feature_show_address, false}]},
                   {friendship, card, [{title, <<"Card - New friendship">>}, {feature_show_address, false}]},
                   {private_message, card, [{title, <<"Card - Private message">>}, {feature_show_address, false}]},
                   {status_update, card, [{title, <<"Card - Status update">>}, {feature_show_address, false}]},
                   {attend_event, card, [{title, <<"Card - Attending event">>}, {feature_show_address, false}]},
                   {tag_picture, card, [{title, <<"Card - Tag in picture">>}, {feature_show_address, false}]},
                   {join_group, card, [{title, <<"Card - Joined group">>}, {feature_show_address, false}]},
                   {photo_prompt, card, [{title, <<"Card - Photo prompt">>}, {feature_show_address, false}]}

                  ],
       predicates=[
                   {has_chapter,
                    [{title, <<"Chapters">>}],
                    [{story, chapter}]},
                   {network,
                    [{title, <<"Network">>}],
                    [{story, historical_person}]},
                   {thumbnail,
                    [{title, <<"Thumbnail">>}],
                    [{story, media}]},
                   {has_zone,
                    [{title, <<"Zones">>}],
                    [{chapter, zone}]},
                   {has_beacon,
                    [{title, <<"Beacons">>}],
                    [{zone, beacon}]},
                   {has_card,
                    [{title, <<"Cards">>}],
                    [{chapter, card}]},
                   {target,
                    [{title, <<"Target">>}],
                    [{card, historical_person}]},
                   {author,
                    [{title, <<"Author">>}],
                    [{card, historical_person}]},
                   {has_group,
                    [{title, <<"Part of group">>}],
                    [{person, group}]},
                   {has_hashtag,
                    [{title, <<"Hashtags">>}],
                    [{card, hashtag}]},
                   {likes,
                    [{title, <<"Likes">>}],
                    [{profile, card}
                    ]},
                   {read,
                    [{title, <<"Has read">>}],
                    [{profile, card}
                    ]},
                   {photoupload,
                    [{title, <<"Uploaded photo">>}],
                    [{profile, media}]},
                   {has_story,
                    [{title, <<"Belonging to story">>}],
                    [{media, story}]}
                  ]
      }.


observe_rsc_update(#rsc_update{}, {Ch0, Props0}, _) ->
    KV = proplists:get_value(keyvalue, Props0),
    {Ch, Props} = case KV of
                      undefined -> {Ch0, Props0};
                      V ->
                          lager:warning("V: ~p", [V]),
                          KeyValue = z_convert:convert_json(mochijson:decode(z_html:unescape(V))),
                          {true, z_utils:prop_replace(keyvalue, KeyValue, Props0)}
                  end,
    lists:foldl(
      fun(K, {Ch1, Props1}) ->
              case proplists:get_value(K, Props) of
                  undefined ->
                      {Ch1, Props1};
                  T ->
                      Props2 = z_utils:prop_replace(K, z_convert:to_integer(T), Props1),
                      {true, Props2}
              end
      end,
      {Ch, Props},
      [time, major, minor]
     ).


observe_service_authorize(#service_authorize{}, Context) ->
    ReqData = z_context:get_reqdata(Context),
    case z_context:get_req_header("authorization", Context) of
        "E-mail " ++ Email ->
            case z_email_utils:is_email(Email) of
                true ->
                    case m_identity:lookup_by_type_and_key(email_only, Email, Context) of
                        undefined ->
                            authorize("Unknown email, please login first.", Context);
                        R ->
                            UserId = proplists:get_value(rsc_id, R),
                            AuthContext = z_acl:logon(UserId, Context),
                            {true, ReqData, AuthContext}
                    end;
                false ->
                    authorize("Valid e-mail address required.", Context)
            end;
        _ ->
            authorize("Authorization required.", Context)
    end.


authorize(Reason, Context) ->
    ReqData = z_context:get_reqdata(Context),
    ReqData1 = wrq:set_resp_body(Reason ++ "\n", ReqData),
    {{halt, 401}, ReqData1, Context}.
