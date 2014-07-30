require 'cloud_foundry_manager'
require 'redis_circular_ordered_set'

current_valuation = 0

app = CloudFoundryManager.application

time_to_store_in_seconds = 160

cpu_usage_history = RedisCircularOrderedSet.new(Dashing.redis, 'altorosdemo-cpu-usage-set', time_to_store_in_seconds)
# mem_usage_history = RedisCircularOrderedSet.new(Dashing.redis, 'altorosdemo-mem-usage-set', time_to_store_in_seconds)

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

    current_time = Time.now.in_time_zone(Time.zone)

    # cpu_usage_average = (cpu_usage_average).round(3)
    cpu_usage_history.add(current_time, cpu_usage_average)


    Dashing.send_event('cpu-meter', {value: cpu_usage_average.round(2)})
    Dashing.send_event('mem-meter', {value: mem_usage_average.round(2)})
    # Dashing.send_event('cpu-average', data: cpu_usage_history.compact, displayValue: Process.pid, title: 'CPU')
    l = cpu_usage_history.list
    puts l.size
    Dashing.send_event('cpu-average', data: l, displayValue: cpu_usage_average)
    Dashing.send_event('total-instances', title: 'Total Instances', current: total_instances)
    Dashing.send_event('running-instances', title: 'Running Instances', current: running_instances)

    app_created_at_with_zone = app.created_at.in_time_zone(Time.zone)
    Dashing.send_event('deployed-at', text: app_created_at_with_zone.strftime("%B %d, %Y at %I:%M%p"))
  end
end
