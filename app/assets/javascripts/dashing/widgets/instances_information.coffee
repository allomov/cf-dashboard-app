class Dashing.InstancesInformation extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered
    $('#instances-dialog', @node).dialog({autoOpen: false, modal: true, width: 700, show : "blind", hide : "blind", minHeight: 500 })
    # console.log $('#instances-dialog', @node)

  table_cell: (content, class_name='') ->
    class_name = ["box", class_name].join(' ')
    "<div class='#{class_name}'>#{content}</div>"

  table_row: (content, class_name='') ->
    class_name = ["box-row", class_name].join(' ')
    "<div class='#{class_name}'>#{content}</div>"

  instance_row: (instance) ->
    row_content = [ instance.index
      instance.cpu
      instance.mem
      instance.disk
      instance.uptime
      instance.state ].map((c) => @table_cell(c, 'instance-info')).join("\n")
    @table_row(row_content, 'instance-info-row')


  instances_available: (flag) ->
    $(".instances-#{if flag then '' else 'un'}available", @node).show()
    $(".instances-#{if flag then 'un' else ''}available", @node).hide()

  show_all_instances: (event) ->
    $('#instances-dialog .instance-info-row', @node).remove()
    dialog_table = @instances.map((c) => @instance_row(c)).join("\n")
    $('#instances-dialog .table', @node).append(dialog_table)
    $('#instances-dialog').dialog('open')
    false

  onData: (data) ->
    data = data.data

    f = Batman.Filters

    @instances = new Batman.Set()
    for index, value of data
      s = if value.stats? then value.stats else {usage: {cpu: '-', mem: '-', disk: '-'}, uptime: '-'}
      u = s.usage
      @instances.add
        index:  index
        cpu:    f.humanize_percents u.cpu
        mem:    f.humanize_memory   u.mem
        disk:   f.humanize_memory   u.disk
        uptime: f.humanize_time     s.uptime
        state:  f.capitalize        f.downcase(value.state)
    
    if @instances.length == 0
      @instances_available(false)
    else
      @instances_available(true)
      
      @instances = @instances.sortedBy("index")
      displayed_values = @instances.toArray()[0..3]

      widget_table = displayed_values.map((c) => @instance_row(c)).join("\n")

      $('.instance-info-row', @node).remove()
      $('.instances-information.table', @node).append(widget_table)
  
      $('.total-instances-count',  @node).text(@instances.length)
      # $('.widget-instances-count', @node).text(if instances.length < 4 then instances.length else 4)
      
      more_button = $('.more-instances-information', @node)
      if @instances.length > 4 then more_button.hide() else more_button.show()
