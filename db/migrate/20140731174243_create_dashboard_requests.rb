class CreateDashboardRequests < ActiveRecord::Migration
  def change
    create_table :dashboard_requests do |t|

      t.timestamps
    end
  end
end
