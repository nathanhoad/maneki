Maneki
======

Maneki is a simple file-based model for your Ruby projects. Give it a directory and it will parse any relevant files within.

For example you might have a model like this:

    class Document < Maneki
      path '../content/documents'
    end

...and a directory, `documents`, that contains a bunch of markdown documents:

    documents/
      first-document.text
      second-document.text
      third-document.text

...and each file might be in a form similar to:

    # This is the title
    
     - published: yes
     - authors: Aristoclea Cattington, Sebastian Fluffybottom
    
    This is the content of the document. It is written in Markdown.

This example parsed document would have the following properties:

 - Title: This is the title
 - Headers:
   - Published: True
   - Authors: 
     - 'Aristoclea Cattington'
     - 'Sebastian Fluffybottom'
 - Body: This is the content of the document. It is written in Markdown.


Getting some documents
----------------------

If you want all of the documents.

    Document.all

Or you can find items by their slug.

    Document.find :slug => 'test-document'
    
Or you can also search for the inclusion of certain headers.

    Document.find :headers => { :published => true }
    Document.find :headers => { :authors => 'Aristoclea Cattington' }

You can also grab any documents from a given category (read on).


Document categories
-------------------

If documents are found within folders then they will also be added to a categorised list.

For example, given this directory structure:

    content/
      documents/
        first-document.text
        second-document.text
        third-document.text
      projects/
        a-project.text
        here-is-another-project.text

Now assume that Maneki has its path set to `content`:

    Maneki.path = 'content'

Here if we want to grab any posts we can just ask for the category.

    Maneki.documents

Here we will get:

 - First document
 - Second document
 - Third document

Whereas if you did:

    Maneki.projects

You would get:

 - A Project
 - Here is another project

If you want to get a list of the found categories then ask for it.

    Maneki.categories


Example project
------------

Maneki is currently powering [nathanhoad.net](http://nathanhoad.net) (along with Sinatra) so feel free to [check out the source](http://github.com/nathanhoad/nathanhoad).


Suggestions?
------------

[Find me on Twitter](http://twitter.com/nathanhoad)