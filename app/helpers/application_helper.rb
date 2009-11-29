# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # inserts a page heading into the layout file
  # use this instead of a <h1> tag
  # eg. - page_heading "foo #{bar}"
  def page_heading(text)
    content_for :page_heading do
      h(text)
    end
  end

  def navigation_li_link_to(text, path)
    if @active_navigation.present? && @active_navigation == text
      content_tag :li, link_to(text, path), :class => 'active'
    else
      content_tag :li, link_to(text, path)
    end
  end

  def sub_navigation_li_link_to(text, path, options = {})
    output = []
    if @active_sub_navigation.present? && @active_sub_navigation == text
      output << "<li class=\"active\">"
    else
      output << "<li>"
    end
    output << link_to(text, path, options)
    output << "</li>"
    output.join('')
  end
end
