class TooltipFilter < Banzai::Filter
  def call(input)
    input.gsub(/\^\[([a-zA-Z0-9\s:\-]+)\]\((.+?)\)/) do
      "<span class='tooltip' data-text='#{$2}' tabindex='0'>#{$1}</span> "
    end
  end
end
