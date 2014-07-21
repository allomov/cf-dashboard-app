require 'cloud_foundry_manager'
require 'circular_buffer'

current_valuation = 0

app = CloudFoundryManager.application

time = 0
time_to_store = 60
cpu_usage_history = CircularBuffer.new(time_to_store)
mem_usage_history = CircularBuffer.new(time_to_store)

Dashing.scheduler.every '1s', allow_overlapping: false do

  stats = app.stats.values
  usage = stats.map { |s| s[:stats][:usage] }

  mem_usage = usage.map { |u| u[:mem] }
  cpu_usage = usage.map { |u| u[:cpu] }
  
  mem_usage_average = (mem_usage.sum / mem_usage.count) / 1048576   # mb
  cpu_usage_average = ((cpu_usage.sum / cpu_usage.count) * 100).round(3)       # persents
  
  time = time + 1

  cpu_usage_history << {'x' => time, 'y' => cpu_usage_average}
  mem_usage_history << {'x' => time, 'y' => mem_usage_average}

  Dashing.send_event('cpu-meter', {value: cpu_usage_average})
  Dashing.send_event('mem-meter', {value: mem_usage_average})
  Dashing.send_event('cpu-average', points: cpu_usage_history, displayValue: "#{cpu_usage_average}%")
  Dashing.send_event('mem-average', points: mem_usage_history, displayValue: "#{mem_usage_average}Mb")
  
  # Dashing.send_event('valuation', { current: current_valuation, last: last_valuation })
  # Dashing.send_event('synergy',   { value: rand(100) })
end