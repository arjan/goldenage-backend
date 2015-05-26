-module(service_goldenage_storydata).

-export([process_get/2]).

process_get(_, Context) ->
    RscId = m_rsc:name_to_id_check(z_context:get_q("id", Context), Context),
    {name, story} = proplists:lookup(name, m_rsc:p(RscId, category, Context)),
    {struct, [{id, RscId}]}.


%% chapters
%% zones + beacons
