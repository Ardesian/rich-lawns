class AdServicesAt < ActiveRecord::Migration[5.2]
  def change
    add_column :service_jobs, :serviced_at, :datetime
    add_column :service_items, :position, :integer

    ServiceJob.find_each do |job|
      job.update(serviced_at: job.created_at)
      job.service_items.order(:updated_at).find_each.with_index do |item, idx|
        item.update(position: idx)
      end
    end

  end
end
