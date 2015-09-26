-module(service_goldenage_photoupload).
-svc_needauth(true).

-export([process_post/2]).

-include_lib("zotonic.hrl").

process_post(_, Context) ->
    CardId = z_convert:to_integer(z_context:get_q("card_id", Context)),
    case z_context:get_q("photo", Context) of
        undefined -> throw({error, missing_photo});
        #upload{}=Upload ->
            case m_media:insert_file(Upload, [], Context) of
                {ok, PhotoId} ->
                    m_edge:insert(z_acl:user(Context), photoupload, PhotoId, Context),
                    case is_integer(CardId) of
                        true ->
                            m_edge:insert(PhotoId, has_card, CardId, Context);
                        false ->
                            nop
                    end;
                _=E ->
                    lager:error("Upload error: ~p", [E]),
                    throw({error, E})
            end
    end,

    ga_util:rsc_json(PhotoId, [image, created], [{width, 800}], Context).




