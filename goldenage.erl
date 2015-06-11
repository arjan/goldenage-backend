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
         observe_rsc_update/3]).

%%====================================================================
%% support functions go here
%%====================================================================

manage_schema(install, _Context) ->
    #datamodel{
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
                   {join_group, card, [{title, <<"Card - Joined group">>}, {feature_show_address, false}]}

                  ],
       predicates=[
                   {has_chapter,
                    [{title, <<"Chapters">>}],
                    [{story, chapter}]},
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
                   {liked_by,
                    [{title, <<"Liked by">>}],
                    [{card, historical_person}]}
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
