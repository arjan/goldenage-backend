%% @author Arjan Scherpenisse
%% @copyright 2015 Arjan Scherpenisse
%% Generated on 2015-05-26
%% @doc Dev website for the Golden Age project

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

-module(goldenage_dev).
-author("Arjan Scherpenisse").

-mod_title("goldenage zotonic site").
-mod_description("Dev website for the Golden Age project").
-mod_prio(10).
-mod_schema(1).

-include_lib("zotonic.hrl").

-export([
         manage_schema/2,
         observe_acl_is_allowed/2,
         observe_rsc_update/3,
         observe_service_authorize/2
        ]).

manage_schema(A,B) ->
    goldenage:manage_schema(A,B).

observe_acl_is_allowed(A,B) ->
    goldenage:observe_acl_is_allowed(A,B).

observe_rsc_update(A,B,C) ->
    goldenage:observe_rsc_update(A,B,C).

observe_service_authorize(A,B) ->
    goldenage:observe_service_authorize(A,B).

