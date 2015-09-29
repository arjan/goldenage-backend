-module(service_goldenage_groupinfo).

-export([process_get/2]).

-include_lib("zotonic.hrl").


process_get(_, Context) ->
    Id = m_rsc:name_to_id_check(z_context:get_q("id", Context), Context),
    {name, N} = proplists:lookup(name, m_rsc:p(Id, category, Context)),
    case z_convert:to_binary(N) of
        <<"group">> -> ok;
        P -> throw({error, not_a_group, z_convert:to_atom(P)})
    end,
    ImgOpts = [{width, 600}],

    ga_util:rsc_json(Id, [title, summary, image, keyvalue, {subject_edges, has_group, members}], ImgOpts, Context).


