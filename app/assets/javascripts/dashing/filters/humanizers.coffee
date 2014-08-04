# `moment` is the moment.js object
Batman.Filters.humanize_time = (time_in_seconds) ->
  time_in_minutes = parseInt(time_in_seconds / 60)
  time_in_hours   = parseInt(time_in_minutes / 60)
  time_in_days    = parseInt(time_in_hours / 24)
  minutes = time_in_minutes % 60
  hours   = time_in_hours   % 24
  days    = time_in_days
  
  if minutes == 0
    '<1min'
  else if hours == 0
    minutes + 'min'
  else if days == 0
    hours + 'h' + minutes + 'min'
  else 
    days + 'd' + hours + 'h' + minutes + 'min'

Batman.Filters.humanize_memory = (memory_in_kilobytes) ->
  memory_in_megabytes = parseInt(memory_in_kilobytes % 1024)
  memory_in_gigabytes = parseInt(memory_in_megabytes % 1024)
  megabytes = memory_in_kilobytes % 1024
  gigabytes = memory_in_gigabytes
  if megabytes == 0
    '<1Mb'
  else if gigabytes == 0
    megabytes + 'Mb'
  else 
    gigabytes + 'Gb'

Batman.Filters.humanize_percents = (value) ->
  percents = parseFloat(value) * 100
  percents = Math.round(parseFloat(percents) * Math.pow(10, 2)) / Math.pow(10, 2)
  percents + '%'
