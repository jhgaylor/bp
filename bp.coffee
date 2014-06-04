#!/usr/local/bin/coffee
# Linux users need a different shebang possible
#!/usr/bin/coffee
# sublime:syntax coffeescript
###
  Boilerplate generator for Meteor
  Author: Jake Gaylor
  Description: CLI tool to generate views/templates/routes/etc for meteor.
  # Help! http://blog.liangzan.net/blog/2012/07/30/how-to-write-a-command-line-application-in-node-dot-js/
###

nopt =    require "nopt"  # https://github.com/npm/nopt
path =    require "path"
fs =      require "fs"
mkdirp =  require "mkdirp"

knownOptions =
  stylesheet: Boolean
  view: Boolean,
  commonView: Boolean,
  name: String
  scaffolding: Boolean,

shortcuts = {
  "S" : ["--scaffolding"]
}

parsed = nopt knownOptions, shortcuts, process.argv, 2

VIEW_JS_TEMPLATE = (name) ->
  return """
    Template.#{name}.helpers

    Template.#{name}.events
  """

VIEW_HTML_TEMPLATE = (name) ->
  return """
    <template name=\"#{name}\">

    </template>
  """

writeFile = (file_path, content) ->
  mkdirp path.dirname(file_path), (err) ->
    if err
      console.log err
      return

    fs.writeFile file_path, content, (err) ->
      if err
        console.log err
      else
        console.log "Wrote: #{file_path}"

makeView = (name, common) ->
  # split name on ':'. Use the last part as the view name
  # use all other sections as a path as well as the fully qualified name
  view_path_parts = name.split(':')
  view_name = view_path_parts.pop()
  view_name_prefix = view_path_parts.join('_')

  # this is a fix to not get _name if there are no other parts
  if view_path_parts.length > 0
    fq_view_name = "#{view_name_prefix}_#{view_name}"
  else
    fq_view_name = view_name

  view_path = path.join 'client', 'views'
  for part in view_path_parts
    view_path = path.join view_path, part
  view_path = path.join view_path, view_name

  view_html_path = path.join view_path, "#{view_name}.html"
  view_js_path = path.join view_path, "#{view_name}.coffee"

  writeFile view_html_path, VIEW_HTML_TEMPLATE(fq_view_name)
  writeFile view_js_path, VIEW_JS_TEMPLATE(fq_view_name)

makeCommonView = (name) ->
  view_path = path.join 'client', 'views'

  view_html_path = path.join view_path, "#{name}.html"
  writeFile view_html_path, VIEW_HTML_TEMPLATE(name)


makeStylesheet = ->
  stylesheet_path = path.join 'client', 'stylesheets', "#{name}.less"
  stylesheet_template = """
    @import "/packages/bootstrap3-less/bootstrap.lessimport";
    @import "common.lessimport";
  """
  writeFile stylesheet_path, stylesheet_template

makeProjectScaffolding = ->
  console.log("foo")
  base_path = './'

  # server stuff
  mkdirp.sync path.join(base_path, "server", "fixtures")
  mkdirp.sync path.join(base_path, "server", "startup")
  mkdirp.sync path.join(base_path, "server", "publications")
  mkdirp.sync path.join(base_path, "server", "routes")

  # shared stuff that loads first-ish
  mkdirp.sync path.join(base_path, "lib", "models")

  # client stuff
  mkdirp.sync path.join(base_path, "client", "routes", "controllers")
  mkdirp.sync path.join(base_path, "client", "config")
  mkdirp.sync path.join(base_path, "client", "helpers")
  mkdirp.sync path.join(base_path, "client", "stylesheets")
  mkdirp.sync path.join(base_path, "client", "views")

  # static files
  mkdirp.sync path.join(base_path, "public")
  mkdirp.sync path.join(base_path, "private")



###
Begin 'driver'
###

if parsed.view
  # coffee bp -vcn loading
  if parsed.commonView
    makeCommonView(parsed.name)
  # coffee bp -vn home
  else
    makeView(parsed.name)

if parsed.stylesheet
  makeStylesheet(parsed.name)

#TODO: models (allow deny + collectin + model class)

if parsed.help
  console.log """
    Hello!

    ./bp -vn admin:dashboard
  """

if parsed.scaffolding
  makeProjectScaffolding()

# console.log parsed;
