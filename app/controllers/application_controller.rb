class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  def parameter_missing
    render json: { error: 'Missing/Empty parameters' }, status: :unprocessable_entity
  end
  def record_invalid(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
  def record_not_found(e)
    error_message = e || "Record Not Found"
    if e.model
      error_message = e.model + " Not Found"
    end
    render json: { error: error_message}, status: :not_found
  end
  private def params
    request.params
  end

  private def query_params
    @query_params ||= request.query_parameters.symbolize_keys
  end

  private def request_body
    @request_body ||= request.request_parameters.symbolize_keys
  end

  def render_json(object, status = :ok, options = nil)
    render json: object, status: status
  end
end
