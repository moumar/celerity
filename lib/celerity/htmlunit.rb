module Celerity
  Jars = Dir[File.dirname(__FILE__) + '/htmlunit/*.jar']
  Jars.each { |jar| require(jar) }
  
  include_class org.apache.commons.httpclient.Cookie
end



module HtmlUnit
  include_package 'com.gargoylesoftware.htmlunit'

  module Html
    include_package 'com.gargoylesoftware.htmlunit.html'
  end
  
  module Util
    include_package 'com.gargoylesoftware.htmlunit.util'
  end
  
end

module Java::OrgW3cDom::NamedNodeMap
  include Enumerable

  def each
    0.upto(getLength - 1) do |idx|
      yield item(idx)
    end
  end
end

module Java::JavaLang::Iterable
  include Enumerable

  def each
    it = iterator
    yield it.next while it.hasNext
  end

end


class Java::ComGargoylesoftwareHtmlunitHtml::HtmlPage
  def inspect
    '#<HtmlPage:0x%s(%s)>' % [self.hash.to_s(16), getWebResponse.getUrl.toString]
  end
end

