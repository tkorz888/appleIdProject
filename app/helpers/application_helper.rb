module ApplicationHelper
  def nav2 name, href, highlight, icon, c = nil
    c = (controller.controller_name == highlight ? "current" : "")
    content_tag :li, :class => c do
      link_to href do
        (content_tag(:i,'', :class => "menu-icon fa #{icon}") + content_tag(:span, name)).html_safe
      end
    end
  end

end
