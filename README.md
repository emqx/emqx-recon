
emqx-recon
==========

EMQ X Recon debug/optimize plugin

Load the Plugin
---------------

```
./bin/emqx_ctl plugins load emqx_recon
```

Commands
--------

```
./bin/emqx_ctl recon

recon memory                            #recon_alloc:memory/2
recon allocated                         #recon_alloc:memory(allocated_types, current|max)
recon bin_leak                          #recon:bin_leak(100)
recon node_stats                        #recon:node_stats(10, 1000)
recon remote_load Mod                   #recon:remote_load(Mod)
```

GC
--

When the plugin is loaded, global GC will run periodically.

License
-------

Apache License Version 2.0

Author
------

EMQ X Team.

