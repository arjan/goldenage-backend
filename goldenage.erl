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
                    [{title, <<"Golden Age">>}]},
                   {story,
                    goldenage,
                    [{title, <<"Story">>}]},
                   {chapter,
                    goldenage,
                    [{title, <<"Chapter">>}]},
                   {zone,
                    goldenage,
                    [{title, <<"Zone">>}]},
                   {beacon,
                    goldenage,
                    [{title, <<"Beacon">>}]},
                   {card,
                    goldenage,
                    [{title, <<"Card">>}]},
                   {group,
                    goldenage,
                    [{title, <<"Person group">>}]}
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
                    [{card, person}]},
                   {has_group,
                    [{title, <<"Part of group">>}],
                    [{person, group}]}
                  ]
      }.

observe_rsc_update(#rsc_update{}, {Ch, Props}, _) ->
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
