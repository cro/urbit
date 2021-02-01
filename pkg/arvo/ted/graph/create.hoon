/-  spider,
    graph=graph-store,
    metadata=metadata-store,
    *group,
    group-store,
    inv=invite-store,
    push-hook
/+  strandio, resource, graph-view
=>
|% 
++  strand  strand:spider
++  poke  poke:strandio
++  poke-our   poke-our:strandio
::
++  handle-group
  |=  [rid=resource =associated:graph-view]
  =/  m  (strand ,resource)
  ?:  ?=(%group -.associated)
    (pure:m rid.associated)
  =/  push-hook-act=cage
    :-  %push-hook-action 
    !>  ^-  action:push-hook
    [%add rid]
  ;<  ~  bind:m    
    (poke-our %metadata-push-hook push-hook-act)
  ;<  ~  bind:m
     %+  poke-our  %group-store
     :-  %group-update
     !>  ^-  update:group-store
     [%add-group rid policy.associated %.y]
  ;<  =bowl:spider  bind:m  get-bowl:strandio
  ;<  ~  bind:m
    (poke-our %group-store group-update+!>([%add-members rid (sy our.bowl ~)]))
  ;<  ~  bind:m
    (poke-our %group-push-hook push-hook-act)
  (pure:m rid)
--
::
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ =action:graph-view] arg)
?>  ?=(%create -.action)
;<  =bowl:spider  bind:m  get-bowl:strandio
::
::  Add graph to graph-store
::
?.  =(our.bowl entity.rid.action)
  (strand-fail:strandio %bad-request ~)
=/  overwrite=?
  ?=(%policy -.associated.action)
=/  =update:graph
  [%0 now.bowl %add-graph rid.action *graph:graph mark.action overwrite]
;<  ~  bind:m
  (poke-our %graph-store graph-update+!>(update))
;<  ~  bind:m
  (poke-our %graph-push-hook %push-hook-action !>([%add rid.action]))
::
::  Add group, if graph is unmanaged
::
;<  group=resource  bind:m
  (handle-group rid.action associated.action)
::
::  Setup metadata
::
=/  =metadatum:metadata
  %*  .  *metadatum:metadata
    title         title.action
    description   description.action
    date-created  now.bowl
    creator       our.bowl
    module        module.action
    preview       %.n
  ==
=/  met-action=action:metadata
  [%add group graph+rid.action metadatum]
;<  ~  bind:m
  (poke-our %metadata-push-hook metadata-update+!>(met-action))
::
::  Send invites
::
?:  ?=(%group -.associated.action)
  (pure:m !>(~))
?-    -.policy.associated.action
    %open  (pure:m !>(~))
    %invite
  =/  inv-action=action:inv
    :^  %invites  %graph  (shaf %graph-uid eny.bowl)
    ^-  multi-invite:inv
    :*  our.bowl
        %graph-push-hook
        rid.action
        pending.policy.associated.action
        description.action
    ==
  ;<  ~  bind:m
    (poke-our %invite-hook %invite-action !>(inv-action))
  (pure:m !>(~))
==
