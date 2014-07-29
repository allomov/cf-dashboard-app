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

    data = [{time: new Date(), y:0}]


    @svg = d3.select(@node)
            .append('svg:svg')
            .attr('width', width)
            .attr('height', height).attr('id', 'metrics-graph');

    # console.log(@)


    @svg.append("svg:rect")
        .attr('class', 'background').attr('width', width).attr('height', height)
       # .attr("transform", "translate(" + margin[3] + "," + margin[0] + ")");

    # @svg.selectAll('path').data(data).enter()
    #     .append("path").attr('class', 'participants').attr('d',
    #         d3.svg.area().interpolate('basis')
    #         .x((d, i) -> timeScale(new Date(d.time)))
    #         .y0(height)
    #         .y1((d, i) -> yScale(d.value)))

    # @svg.data(@get('data')) if @get('data')

  onData: (data) ->
    data = data.data

    minTime  = d3.min(data, (d) -> new Date(d.time))
    timeDomainInSeconds = 60;
    
    maxTime = Math.max(d3.max(data, (d) -> new Date(d.time)), new Date(minTime.getTime() + timeDomainInSeconds*1000))
    @timeScale  = d3.time.scale().domain([minTime, maxTime]).range([0, @width])
    @yScale = d3.scale.linear().domain([0, 100]).range([@height, 0])

    xAxis = d3.svg.axis().scale(@timeScale)
                  .tickSubdivide(false).tickFormat(d3.time.format('%e %b'))
                  .tickSize(0).tickPadding(10)

    yAxis = d3.svg.axis().scale(@yScale).ticks(4).orient("right").tickSize(0).tickSubdivide(true)

    path_finder = d3.svg.area().interpolate('basis')
              .x((d, i) => @timeScale(new Date(d.time)))
              .y0(@height)
              .y1((d, i) => @yScale(d.value))
    
    # console.log(@data)

    @svg.selectAll("path").remove()
    
    path = @svg.selectAll("path").data([data])
    
    # debugger;

    path.enter().append("path").attr('class', 'values').attr('stroke', 'red')
          .attr('style', 'fill: red').attr('d', path_finder(data))
    
    # path.exit().remove()
