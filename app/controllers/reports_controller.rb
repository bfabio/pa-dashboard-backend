class ReportsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid,
              ActionController::ParameterMissing, with: :invalid

  before_action :set_host, except: :index
  before_action :authenticate, except: :index

  # GET /reports
  def index
    @reports = Report.all

    render json: @reports
  end

  # PATCH/PUT /reports/:hostname/:key
  def update
    @report = Report.find_by(key: params[:key], hostname: @hostname)

    if @report
      @report.update!(report_params)
      status = :no_content
    else
      @report = Report.create!(report_params.merge(hostname: params[:hostname],
                                                   key: params[:key]))
      status = :created
    end

    render json: @report, status: status
  end

  # DELETE /reports/:hostname/:key
  def destroy
    Report.find_by!(key: params[:key], hostname: @hostname).destroy
  end

  private
    def set_host
      @hostname = params[:hostname]
    end

    def report_params
      params.require(:report).permit(:key, :date, :description, :doc_url, :category, :severity)
    end

    def not_found
      render json: { error: 'Report not found' }, status: :not_found
    end

    def invalid(exc)
      render json: { error: exc }, status: :unprocessable_entity
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, _options|
        main_token = ApiToken.where(hostname: '*').pick(:token)
        if main_token && ActiveSupport::SecurityUtils.secure_compare(main_token, token)
          next true
        end

        host_token = ApiToken.where(hostname: @hostname).pick(:token)
        next false if host_token.nil?

        ActiveSupport::SecurityUtils.secure_compare(host_token, token)
      end
    end
end
