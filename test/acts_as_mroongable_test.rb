require 'test_helper'

class ActsAsMroongableTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActsAsMroongable
  end

  test "has scopes" do
    assert_respond_to Book, :mroonga_match
    assert_respond_to Book, :mroonga_snippet
    assert_respond_to Book, :select_with_new_column
  end

  test "select_with_new_column" do
    assert_equal "SELECT \"books\".\"id\", \"books\".\"abstract\" FROM \"books\"", Book.select("id").select_with_new_column('abstract').to_sql, "with select_values"
    assert_equal "SELECT *, \"books\".\"abstract\" FROM \"books\"", Book.select_with_new_column('abstract').to_sql, "without select_values"
  end

  test "mroonga_match" do
    assert_equal "SELECT \"books\".* FROM \"books\"  WHERE (MATCH(abstract) AGAINST(mroonga_escape('query', '() \\'\"+-><~*:') IN BOOLEAN MODE))", Book.mroonga_match("query", "abstract").to_sql
  end

  test "mroonga_snippet" do
    assert_equal "SELECT *, mroonga_snippet(abstract, 1500, 1, 'utf8_unicode_ci', 1, 1, '', '', mroonga_escape('query', '() \\'\"+-><~*:'), '<span>', '</span>' ) AS hilighted_abstract FROM \"books\"  WHERE (MATCH(abstract) AGAINST(mroonga_escape('query', '() \\'\"+-><~*:') IN BOOLEAN MODE))", Book.mroonga_match("query", "abstract").mroonga_snippet("query", "abstract").to_sql
  end
end
