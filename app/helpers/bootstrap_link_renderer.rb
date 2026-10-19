require 'will_paginate/view_helpers/action_view'

# Renders will_paginate links using Bootstrap 5 pagination markup.
class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer
  protected

  def html_container(html)
    tag :nav, tag(:ul, html, class: 'pagination'), 'aria-label': 'Pagination'
  end

  def page_number(page)
    if page == current_page
      tag :li, tag(:span, page, class: 'page-link'), class: 'page-item active', 'aria-current': 'page'
    else
      tag :li, link(page, page, class: 'page-link', rel: rel_value(page)), class: 'page-item'
    end
  end

  def gap
    tag :li, tag(:span, '&hellip;'.html_safe, class: 'page-link'), class: 'page-item disabled'
  end

  def previous_or_next_page(page, text, classname, aria_label = nil)
    if page
      tag :li, link(text, page, class: 'page-link', rel: rel_value(page)), class: "page-item #{classname}"
    else
      tag :li, tag(:span, text, class: 'page-link'), class: "page-item #{classname} disabled"
    end
  end
end
