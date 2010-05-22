require 'test/unit'
require File.dirname(__FILE__) + '/../lib/maneki'


class TestManeki < Test::Unit::TestCase
	def setup
		@content_path = File.dirname(__FILE__) + '/content'		
		Maneki.path = @content_path
	end
	
  def test_documents_categories    
    assert Maneki.categories.include?('documents')
    assert_not_equal 0, Maneki.documents.size
    
    documents = Maneki.documents
    assert_kind_of Array, documents
  end
  
  def test_previous_and_next
    documents = Maneki.documents
    first = documents[0]
    second = documents[1]
    other_second = Maneki.find 'documents/second-document'
    third = documents[2]
    
    assert_not_nil Maneki.previous_before(first)
    assert_nil Maneki.previous_before(first, :category => 'documents')
    assert_equal second, Maneki.next_after(first)
    assert_equal other_second, Maneki.next_after(first)
    assert_equal third, Maneki.next_after(second)
    assert_equal third, Maneki.next_after(other_second)
    assert_nil Maneki.next_after(third)
    
    assert_equal first, Maneki.next_after(Maneki.previous_before(first))
  end
end