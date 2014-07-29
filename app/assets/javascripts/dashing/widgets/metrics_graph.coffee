class Dashing.MetricsGraph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    data = @get('data')
    if data
      data[data.length - 1].value

  ready: ->

    # margin = [0, 20, 40, 0];
    # totalHeight = 340, totalWidth = 620;
    # width  = totalWidth  - margin[1] - margin[3];
    # height = totalHeight - margin[0] - margin[2];

    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @height = height
    @width = width

    @time_to_display = 60;
    max_time  = new Date()
    min_time  = new Date(max_time.getTime() - @time_to_display*1000)


    @time_scale  = d3.time.scale().domain([min_time, max_time]).range([0, @width])
    @value_scale = d3.scale.linear().domain([0, 100]).range([@height, 0])

    @svg = d3.select(@node)
            .append('svg:svg')
            .attr('width', width)
            .attr('height', height).attr('id', 'metrics-graph');

    @svg.append("svg:rect")
        .attr('class', 'background').attr('width', width).attr('height', height)

    @graph_data = []

  onData: (data) ->
    time  = data.current_time
    value = data.current_value
    
    return if not @graph_data

    @graph_data.push({ 'time': new Date(time), 'value': value })

    max_time  = new Date()
    min_time  = new Date(max_time.getTime() - @time_to_display*1000)

    @time_scale.domain([min_time, max_time])
    @graph_data = @graph_data.filter((d) => d.time >= min_time.setSeconds(min_time.getSeconds() - 5))


    path_string = d3.svg.area().interpolate('basis')
              .x((d, i) => @time_scale(new Date(d.time)))
              .y0(@height)
              .y1((d, i) => @value_scale(d.value))(@graph_data)
    
    
    @svg.selectAll("path").remove()
    
    # path = @svg.selectAll("path").data([@graph_data])

    @svg.append("path").attr('class', 'values').attr('stroke', 'red')
          .attr('style', 'fill: red').attr('d', path_string)
    
    # path.exit().remove()
    # xAxis = d3.svg.axis().scale(@time_scale)
    #               .tickSubdivide(false).tickFormat(d3.time.format('%e %b'))
    #               .tickSize(0).tickPadding(10)

    # yAxis = d3.svg.axis().scale(@value_scale).ticks(4).orient("right").tickSize(0).tickSubdivide(true)
