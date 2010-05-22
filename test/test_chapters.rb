require 'test/unit'
require File.dirname(__FILE__) + '/../lib/maneki'
require File.dirname(__FILE__) + '/chapter'


class TestChapters < Test::Unit::TestCase
	def test_document_load	  
		chapter = Chapter.new :filename => File.dirname(__FILE__) + '/content/chapters/01-the-first-chapter.text'		
		assert_kind_of Chapter, chapter
		assert_equal '01-the-first-chapter', chapter.slug
		assert_equal 'Chapter 1: The first chapter', chapter.title
		assert_equal 'This is the content of this chapter.', chapter.body
		assert_equal({}, chapter.headers)
	end

	def test_chapters_load
		assert_not_equal 0, Chapter.all.size
	end
	
	def test_find
	  chapter = Chapter.find '01-the-first-chapter'
	  assert_kind_of Chapter, chapter
	  assert_equal 'Chapter 1: The first chapter', chapter.title
	  
	  chapters = Chapter.find :headers => { :boolean_value => true }, :body => 'some headers', :match => :all
	  assert_equal 1, chapters.size
	  
	  chapters = Chapter.find :headers => { :boolean_value => true }, :body => 'some headers', :match => :any
	  assert_equal 2, chapters.size
	  
	  chapters = Chapter.find :headers => { :boolean_value => true }
	  assert_not_equal 0, chapters.size
	  
	  chapters = Chapter.find :headers => { :list_values => 'are' }
	  assert_not_equal 0, chapters.size
  end
  
  def test_headers
    chapter = Chapter.find '01-the-first-chapter'
    assert_equal({}, chapter.headers)
    
    chapter = Chapter.find '03-chapter-with-headers'
    assert_not_equal({}, chapter.headers)
    assert_equal 'Here is a chapter written by a guest author. It has some headers.', chapter.body
    
    assert_kind_of Array, chapter.headers[:list_values]
    assert_kind_of TrueClass, chapter.headers[:boolean_value]
    assert_kind_of FalseClass, chapter.headers[:another_boolean]
  end
end
