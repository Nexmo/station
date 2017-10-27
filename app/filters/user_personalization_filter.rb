class UserPersonalizationFilter < Banzai::Filter
  def call(input)
    # return unless current_user

    # input.gsub!(/\NEXMO_API_KEY/, "'#{current_user.api_key}'")
    # input.gsub!(/\NEXMO_API_SECRET/,  "'#{current_user.api_secret}'")
    # input.gsub!(/\TO_NUMBER/, "'#{current_user.to_number}'")
    input
  end

  private

  # def current_user
  #   @current_user ||= OpenStruct.new({
  #     api_key: 'abc123',
  #     api_secret: 'abc123',
  #     to_number: '44123456789',
  #   })
  # end
end
