class Admin::ServiceJobsController < Admin::BaseController
  before_action :set_service_job

  def index
    @service_jobs = ServiceJob.order(created_at: :desc)
  end

  def create
    @service_address = ServiceAddress.find_by!(token: params[:service_address_token])
    @client = @service_address.user
    @service_job = @service_address.service_jobs.new(service_job_params)

    if @service_job.save
      @service_address.serviced!
      redirect_to [:admin, :service_addresses], notice: "Job complete. 👍"
    else
      flash.now[:alert] = "Failed to save. Please try again."
      render "admin/service_addresses/show"
    end
  end

  private

  def service_job_params
    params.require(:service_job).permit(
      :date,
      :notes,
      service_items_attributes: [
        :id,
        :_destroy,
        :description,
        :cost_in_pennies,
        :time_in_minutes,
      ]
    )
  end

  def set_service_job
    @service_job = ServiceJob.find(params[:id]) if params[:id].present?
  end
end
