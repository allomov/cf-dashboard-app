require 'mongodb_manager'

Dashing.scheduler.every '1s', allow_overlapping: false do
  available = MongodbManager.available?
  count = available ? MongodbManager.collection.count : 0
  Dashing.send_event('mongodb-widget', { mongodb_available: available, documents_count: count})
end