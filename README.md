# elixir_conf_chores

This repository was create to support a talk at [ElixirConf 2016](http://www.elixirconf.com/) titled __Nerves+Phoenix Saves a Father's Sanity__ in which I discuss how I was able to use an application very similar to this to build a wifi router for my home which supports a captive portal for assisting my family members to know what their chores chores are every day and will unlock internet connections once each of the family member's chores are done for the day.

Umbrella Project:
- :firmware - nerves project to support building new bootable system on an sd card for the raspberry pi v3 single board computer
  - _NOTE_: burning firmware should happen from within this application directory
- :user_interface - phoenix application for chore navigation / captive portal and administrative functions
- :captive_portal_login_redirector - redirects new connections to the :user_interface / captive portal application
- :chore_repository - application which is responsible for persistence of chore data
- :router_controls - utility functions for wrapping several useful OS commands

**NOTE:** For more information about how to work with nerves, reference the [nerves project site](http://nerves-project.org/)
