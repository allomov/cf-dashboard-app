class Dashing.MetricsGraph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    data = @get('data')
    if data
      data[data.length - 1].value

  ready: ->

    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @height = height
    @width = width

    @time_to_display = 5 * 60;

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

    @svg.append("path")
          .attr('class', 'values')
          .attr('stroke', 'red')
          .attr('style', 'fill: red')

    @time_axis = d3.svg.axis().ticks(d3.time.minutes, 1)
                  .tickSubdivide(false).tickFormat(d3.time.format('%H:%M'))
                  .tickSize(0).tickPadding(10)

    @value_axis = d3.svg.axis().scale(@value_scale).tickValues([20, 40, 60, 80]).orient("left").tickSize(0).tickSubdivide(true);

    @svg.append("svg:g")
        .attr("class", "y-axis")
        .attr("transform", "translate(35,0)")
        .call(@value_axis);

  onData: (data) ->

    return unless @time_scale?

    @graph_data = data.data

    max_time  = new Date()
    max_time  = new Date(max_time.getTime() - 1000)
    min_time  = new Date(max_time.getTime() - @time_to_display*1000)

    # min = d3.min(@graph_data, (d) -> new Date(d.time))
    # max = d3.max(@graph_data, (d) -> new Date(d.time))
    # console.log("---------")
    # console.log(">>>min: " + min_time)
    # console.log(">>>max: " + max_time)
    # console.log("min: " + min)
    # console.log("max: " + max)
    # console.log("---------")

    @time_scale.domain([min_time, max_time])
    # @graph_data = @graph_data.filter((d) => d.time >= min_time.setSeconds(min_time.getSeconds() - 5))

    path_string = d3.svg.area().interpolate('basis')
              .x((d, i) => @time_scale(new Date(d.time)))
              .y0(@height)
              .y1((d, i) => @value_scale(d.value))(@graph_data)

    
    # @svg.selectAll("path").remove()
    
    # path = @svg.selectAll("path").data([@graph_data])

    # @svg.append("path").attr('class', 'values').attr('stroke', 'red')
    #       .attr('style', 'fill: red').attr('d', path_string)

    @svg.select("path").attr('d', path_string)

    @time_axis = @time_axis.scale(@time_scale)
                  
    @svg.select("g.x-axis").remove()
    @svg.append("svg:g")
        .attr("class", "x-axis")
        .attr("transform", "translate(0," + (@height - 30) + ")")
        .call(@time_axis)

    # yAxis = d3.svg.axis().scale(@value_scale).ticks(4).orient("right").tickSize(0).tickSubdivide(true)

    # path.exit().remove()
