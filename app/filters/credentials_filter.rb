class CredentialsFilter < Banzai::Filter
  def call(input)
    # Remove frontmatter from the input
    # input.gsub(/API_KEY/, SecureRandom.hex)
    input
  end
end
