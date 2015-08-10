module ActsAsMroongable
  module Core
    extend ActiveSupport::Concern

    GROONGA_ESCAPE_CHARS = %q{() \'"+-><~*:} # see detail for http://groonga.org/ja/docs/reference/grn_expr/query_syntax.html, http://mroonga.org/ja/blog/2013/08/29/release.html

    included do
    end

    module ClassMethods
      def acts_as_mroongable(options = {})
        scope :mroonga_match, ->(query, columns) do
          raise ArgumentError if query.blank? || columns.blank?

          query = self.connection.quote(query)

          where("MATCH(#{columns}) AGAINST(mroonga_escape(#{query}, '#{GROONGA_ESCAPE_CHARS}') IN BOOLEAN MODE)")
        end

        scope :mroonga_snippet, ->(query, column, options = {}) do
          raise(ArgumentError, "specify both query and column") if query.blank? || column.blank?

          # args of mroonga_snippet()
          keyword_prefix = options[:keyword_prefix] || "<span>"
          keyword_suffix = options[:keyword_suffix] || "</span>"
          max_bytes = options[:max_bytes] || 1500
          max_count = options[:max_count] || 1
          encoding = options[:encoding] || "utf8_unicode_ci"
          skip_leading_spaces = options[:skip_leading_spaces] || 1
          html_escape = options[:html_escape] || 1
          snippet_prefix = options[:snippet_prefix] || ""
          snippet_suffix = options[:snippet_suffix] || ""
          result_column_prefix = options[:result_column_prefix] || "hilighted_"

          query = "mroonga_escape(#{self.connection.quote(query)}, '#{GROONGA_ESCAPE_CHARS}')"
          snippet_query = "#{query}, '#{keyword_prefix}', '#{keyword_suffix}'"
          snippet = "mroonga_snippet(#{column}, #{max_bytes}, #{max_count}, '#{encoding}', #{skip_leading_spaces}, #{html_escape}, '#{snippet_prefix}', '#{snippet_suffix}', #{snippet_query} ) AS #{result_column_prefix}#{column}"

          select_with_new_column(snippet)
        end

        scope :select_with_new_column, ->(query) {
          result = current_scope || relation
          result = result.select('*') if result.select_values.blank?
          result.select(query)
        }

      end
    end
  end
end
