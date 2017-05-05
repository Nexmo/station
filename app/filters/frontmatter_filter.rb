class FrontmatterFilter < Banzai::Filter
  def call(input)
    # Remove frontmatter from the input
    input.gsub(/^(---.+?---)/mo, '')
  end
end
