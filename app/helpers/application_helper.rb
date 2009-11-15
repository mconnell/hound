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

end
