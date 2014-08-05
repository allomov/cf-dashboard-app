# `moment` is the moment.js object
Batman.Filters.humanize_time = (time_in_seconds) ->
  if time_in_seconds == '-' then return time_in_seconds
  time_in_minutes = Math.round(parseInt(time_in_seconds) / 60)
  time_in_hours   = parseInt(time_in_minutes / 60)
  time_in_days    = parseInt(time_in_hours / 24)
  minutes = time_in_minutes % 60
  hours   = time_in_hours   % 24
  days    = time_in_days
  
  if days != 0
    days + 'd'
  else if hours != 0
    hours + 'h'
  else if minutes != 0
    minutes + 'min'
  else 
    '<1min'

Batman.Filters.humanize_memory = (memory_in_bytes) ->
  if memory_in_bytes == '-' then return memory_in_bytes
  memory_in_kilobytes = parseInt(memory_in_bytes) / 1024
  memory_in_megabytes = parseInt(memory_in_kilobytes / 1024)
  memory_in_gigabytes = parseInt(memory_in_megabytes / 1024)

  megabytes = memory_in_megabytes % 1024
  gigabytes = memory_in_gigabytes
  if gigabytes != 0
    gigabytes + 'Gb'
  else if megabytes != 0
    megabytes + 'Mb'
  else
    '<1Mb'


Batman.Filters.humanize_percents = (value) ->
  if value == '-' then return value
  percents = parseFloat(value) * 100
  percents = Math.round(parseFloat(percents) * Math.pow(10, 2)) / Math.pow(10, 2)
  percents + '%'
