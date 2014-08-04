class Dashing.InstancesInformation extends Dashing.Widget

  @accessor 'instances', ->
    data = @get('data')
    instances = new Batman.Set()
    for index, value of data
      s = value.stats
      u = s.usage
      instances.add
      	index:  index
      	cpu:    u.cpu
      	mem:    u.mem
      	disk:   u.disk
      	uptime: s.uptime
      	state:  value.state
    instances.sortedBy("index")

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
  	# console.log(data)
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
