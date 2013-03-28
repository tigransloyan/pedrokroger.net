module Jekyll
  class CategoryListTag < Liquid::Tag
    def render(context)
      html = ""
      categories = context.registers[:site].categories.keys
      sorted_categories = categories.sort
      categories_butlast = sorted_categories[0..-2]
      category_dir = context.registers[:site].config['category_dir']

      categories_butlast.each do |category|
        posts_in_category = context.registers[:site].categories[category].size
        category_url = File.join(category_dir, category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase)
        html << "<a href='/#{category_url}/'>#{category} (#{posts_in_category})</a> | "
      end

      last_category = sorted_categories[-1]
      posts_in_category = context.registers[:site].categories[last_category].size
      category_url = File.join(category_dir, last_category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase)
      html << "<a href='/#{category_url}/'>#{last_category} (#{posts_in_category})</a> "

      html
    end
  end
end

Liquid::Template.register_tag('category_list', Jekyll::CategoryListTag)
