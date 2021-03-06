module Formatter
  require 'sanitize'

  RELAXED = {
    :elements => [
      'a', 'b', 'blockquote', 'br', 'caption', 'cite', 'code', 'col',
      'colgroup', 'dd', 'dl', 'dt', 'em', 'i', 'img', 'li', 'ol', 'p', 'pre',
      'q', 'small', 'strike', 'strong', 'sub', 'sup', 'table', 'tbody', 'td',
      'tfoot', 'th', 'thead', 'tr', 'u', 'ul', 'del', 'ins', 'h1', 'h2', 'h3', 'h4', 'h5', 'h5', 'hr', 'kbd'],

    :attributes => {
      'a'          => ['href', 'title'],
      'blockquote' => ['cite'],
      'col'        => ['span', 'width'],
      'colgroup'   => ['span', 'width'],
      'img'        => ['align', 'alt', 'height', 'src', 'title', 'width'],
      'ol'         => ['start', 'type'],
      'q'          => ['cite'],
      'table'      => ['summary', 'width'],
      'td'         => ['abbr', 'axis', 'colspan', 'rowspan', 'width'],
      'th'         => ['abbr', 'axis', 'colspan', 'rowspan', 'scope', 'width'],
      'ul'         => ['type'],
      'i'          => ['style']
    },

    :protocols => {
      'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
      'blockquote' => {'cite' => ['http', 'https', :relative]},
      'img'        => {'src'  => ['http', 'https', :relative]},
      'q'          => {'cite' => ['http', 'https', :relative]}
    }
  }

  def format(text)
    return "" unless text

    html = kramdown(text)

    Sanitize.clean(html, RELAXED)
  end

  def self.included base
    return unless base < ActionController::Base
    base.helper_method :format
  end
end
