bp
==

A tool for creating Meteor Boilerplate


## Usage:

--view (-v): Make a view

--common (-c): Make a view a common view


--name (-n): Name the view

--scaffolding (-S): make the folder structure


### To make a project scaffolding

`./bp.coffee -S`

or 


`./bp.coffee --scaffolding`


### To Make a view

`./bp.coffee -vn foo`

`./bp.coffee -vn admin:dashboard`

`./bp.coffee -vn admin:user:list`

`./bp.coffee -vn admin:user:index`

compare with 

`./bp.coffee -vn admin:user_list`

`./bp.coffee -vn admin:user_index`


### To Make a common view (no js file or folders used)

`./bp.coffee -cvn footer`

### To Make a stylesheet

`./bp.coffee -s main`

TODO:

Make into an NPM library
