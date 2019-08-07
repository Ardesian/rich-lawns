class Admin::ServiceJobsController < Admin::BaseController
  before_action :set_service_job

  def index
    @service_jobs = ServiceJob.order(created_at: :desc)
  end

  def new
    @service_address = ServiceAddress.find_by!(token: params[:service_address_token])
    @client = @service_address.user
    @service_job = @service_address.service_jobs.new

    render :form
  end

  def edit
    render :form
  end

  def create
    @service_address = ServiceAddress.find_by!(token: params[:service_address_token])
    @client = @service_address.user
    @service_job = @service_address.service_jobs.new(adjusted_service_job_params)

    if @service_job.save
      @service_address.serviced!
      redirect_to [:admin, :service_addresses], notice: "Job complete. 👍"
    else
      flash.now[:alert] = "Failed to save. Please try again."
      render :form
    end
  end

  def update
    if @service_job.update(adjusted_service_job_params)
      redirect_to [:admin, @service_job], notice: "Job updated."
    else
      flash.now[:alert] = "Failed to save. Please try again."
      render :form
    end
  end

  def deliver_invoice
    @invoice = @service_job.invoice || @service_job.generate_invoice

    if @invoice.recipient.present?
      UserMailer.invoice(@invoice).deliver_later
      flash.notice = "Delivered invoice. 📧"
    else
      flash.alert = "Could not deliver invoice without email."
    end

    redirect_to [:admin, @service_job]
  end

  def mark_paid
    @invoice = @service_job.invoice || @service_job.generate_invoice

    if @invoice.mark_paid
      flash.notice = "Invoice has been marked as paid."
    else
      flash.alert = "Failed to mark invoice as paid."
    end

    redirect_to [:admin, @service_job]
  end

  private

  def adjusted_service_job_params
    new_params = service_job_params.dup
    new_params[:service_items_attributes].tap do |item_params|
      item_params.each do |item_attrs|
        item_attrs.merge!(_destroy: true) if item_attrs[:unit_count].to_f.zero?
      end
    end

    new_params
  end

  def service_job_params
    params.require(:service_job).permit(
      :date,
      :notes,
      service_items_attributes: [
        :id,
        :_destroy,
        :description,
        :unit_count,
        :unit_cost_in_dollars
      ]
    )
  end

  def set_service_job
    return unless params[:id].present?

    @service_job = ServiceJob.find(params[:id])
    @service_address = @service_job.service_address
    @client = @service_address.user
  end
end
