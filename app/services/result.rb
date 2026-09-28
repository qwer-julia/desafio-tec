class Result
  attr_reader :success, :object, :error_message

  def initialize(success:, object:, error_message:)
    @success = success
    @object = object
    @error_message = error_message
  end
end
