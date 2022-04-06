module ChangelogsHelper
  def build_volta_icon(element)
    return '' unless element

    if element.scan(/vonage-(\w+)-sdk/).present?
      element.scan(/vonage-(\w+)-sdk/).flatten.first.downcase
    elsif element.scan(/(\w+) SDK/).present?
      element.scan(/(\w+) SDK/).flatten.first.downcase
    elsif element.scan(/(\w+)-cli/).present?
      element.scan(/(\w+)-cli/).flatten.first.downcase
    end
  end
end
