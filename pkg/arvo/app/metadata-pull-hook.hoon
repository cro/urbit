::  metadata-pull-hook [landscape]:
::
::  allow syncing group data from foreign paths to local paths
::
/-  *group, *invite-store, *metadata-store
/+  default-agent, verb, dbug, store=group-store, grpl=group, pull-hook
/+  resource
~%  %group-hook-top  ..part  ~
|%
+$  card  card:agent:gall
::
++  config
  ^-  config:pull-hook
  :*  %metadata-store
      metadata-update
      %metadata-update
      %metadata-push-hook
  ==
::
--
::
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
%-  (agent:pull-hook config)
^-  (pull-hook:pull-hook config)
|_  =bowl:gall
+*  this        .
    def         ~(. (default-agent this %|) bowl)
    dep         ~(. (default:pull-hook this config) bowl)
::
++  on-init  on-init:def
++  on-save  !>(~)
++  on-load  on-load:def
++  on-poke  on-poke:def
++  on-agent  on-agent:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
++  on-pull-nack
  |=   [=resource =tang]
  ^-  (quip card _this)
  ~&  nacked+resource
  `this
::
++  on-pull-kick
  |=  =resource
  ^-  (unit path)
  `/
--