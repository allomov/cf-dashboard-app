# `moment` is the moment.js object
Batman.Filters.round = (number, count=0) ->
  Math.round(parseFloat(number) * Math.pow(10, count)) / Math.pow(10, count)
