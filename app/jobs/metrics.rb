require 'cloud_foundry_manager'
require 'circular_buffer'

current_valuation = 0

app = CloudFoundryManager.application

time_to_store_in_seconds = 5 * 60
# start_time = Time.now.to_i
# time_range = (start_time .. time_to_store_in_seconds * 1000)
# init_data = time_range.step(1000).map { |t| {'x' => t, 'y' => 0} }

cpu_usage_history = CircularBuffer.new(time_to_store_in_seconds)
mem_usage_history = CircularBuffer.new(time_to_store_in_seconds)

Dashing.scheduler.every '1s', allow_overlapping: false do

  stats = app.stats.values
  usage = stats.map { |s| s.has_key?(:stats) ? s[:stats][:usage] : nil }.compact

  unless usage.empty?
    mem_usage = usage.map { |u| u[:mem] }
    cpu_usage = usage.map { |u| u[:cpu] }

    total_instances = stats.size
    running_instances = app.running_instances
    
    mem_usage_average = (mem_usage.sum / mem_usage.count) / 1048576        # mb
    cpu_usage_average = ((cpu_usage.sum / cpu_usage.count) * 100).round(3) # persents

    time = Time.now.in_time_zone(Time.zone).to_i

    cpu_usage_history << {'x' => time, 'y' => cpu_usage_average}
    mem_usage_history << {'x' => time, 'y' => mem_usage_average}


    Dashing.send_event('cpu-meter', {value: cpu_usage_average.round(2)})
    Dashing.send_event('mem-meter', {value: mem_usage_average.round(2)})
    Dashing.send_event('cpu-average', points: cpu_usage_history, displayValue: "#{cpu_usage_average}%", title: 'CPU')
    # Dashing.send_event('mem-average', points: mem_usage_history, displayValue: "#{mem_usage_average}Mb")
    Dashing.send_event('total-instances', title: 'Total Instances', current: total_instances)
    Dashing.send_event('running-instances', title: 'Running Instances', current: running_instances)

    app_created_at_with_zone = app.created_at.in_time_zone(Time.zone)
    Dashing.send_event('deployed-at', text: app_created_at_with_zone.strftime("%B %d, %Y at %I:%M%p"))
  end
end
