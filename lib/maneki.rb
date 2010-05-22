# = Maneki
# 
# Load documents from a directory and parse them. The idea is that
# any of the given documents (Markdown only for now) should be readable
# in their own format without parsing but be formatted in such way as 
# to present meta information (title, headers, etc) in an easily parsable
# way.
class Maneki  
  # Set the search path
  def self.path= (value)
    path value
  end
  
  # Set or return the search path
  def self.path (value = nil)
    @path = value if value
    @category = File.basename(value) unless @category
    @path
  end
  

  # Set the general category for these documents
  def self.category (value = nil)
    @category = value
    @category
  end
  
  
  # Get a list of all categories
  def self.categories
    prepare
    @categorised.keys
  end
  
  
  # Grab all documents
  def self.all
    prepare
  end
  
  
  # Search for any documents
  def self.find (args = {})
    if args[:slug] or args.is_a? String
      return find_by_slug(args[:slug] || args)
    end
    
    match = args[:match] || :all
    args.delete(:match)
    
    all.select do |item|
      matches = 0
            
      if args[:title] 
        if item.title == args[:title]
          matched ||= true if match == :any
          matches += 1 if match == :all
        else
          matched ||= false if match == :all
        end
      end
      
      if args[:body]
        if item.body.downcase.include? args[:body].downcase
          matched ||= true if match == :any
          matches += 1 if match == :all
        else
          matched ||= false if match == :all
        end
      end
      
      if args[:headers]
        args[:headers].each_pair do |header, value|
          if item.headers[header] and (item.headers[header] == value or item.headers[header].include? value)
            matched ||= true if match == :any
            matches += 1 if match == :all
          else
            matched ||= false if match == :all
          end
        end
      end
      
      matched || (matches >= args.size)
    end
  end
  
  
  # The previous document before a given document
  def self.previous_before (document, args = {})
    prepare
    if args[:category]
      index = @categorised[args[:category]].index(document)
    else
      index = @documents.index(document)
    end
    @documents[index - 1] unless index == 0
  end
  
  # The next document after a given document
  def self.next_after (document, args = {})
    prepare
    if args[:category]
      index = @categorised[args[:category]].index(document)
    else
      index = @documents.index(document)
    end
    @documents[index + 1] unless index == @documents.length
  end
  
  
  # Look up a document category
  def self.method_missing (method, *args)
    prepare
    @categorised[method.to_s] unless @categorised.nil?
  end
  
  
  attr_accessor :filename, :category, :slug, :headers, :title, :body
  
  # Create a new document
  def initialize (args = {})
    @filename = File.expand_path(args[:filename])
    
    @body = ''
    if File.exists? @filename		  
      @category = File.dirname(@filename).split('/').last unless @category		
      @slug = @filename.gsub(File.expand_path(self.class.path) + '/', '').gsub(/\..+$/, '')
      
      body = File.open(@filename).readlines
      body.each do |line|
        line.gsub!("\r", '') # fix up any DOS EOLs
      end

      title = body.find { |item| /^\#.+/.match item }
      body = body[2..body.length-1] if title # consume title

      # check for headers
      @headers = Hash.new
      if /^\s?\-.+/.match(body[0])
        headers_end = body.index("\n") || 1
        headers = body[0..headers_end-1] if headers_end # next blank line is end of headers

        body_start = 1
        body_start = body.index(headers.last) + 1 if headers
        body = body[body_start..body.length - 1] if title

        headers.each do |header|
          unless header.strip == '' or /^\#.+/.match header
            values = header.gsub(/^\s?\-/, '').strip.split(/:\s/)
            key = values.shift.downcase.gsub(/[^\w\_]+/, '_').to_sym
            value = values.join(': ').strip
            # check for special header values (true, false, lists, etc)
            if ['true', 't', 'yes', 'y'].include? value
              value = true
            elsif ['false', 'f', 'no', 'n'].include? value
              value = false
            elsif value.include? ','
              value = value.split(/\,\s?/)
            end
            @headers[key] = value
          end
        end if headers
      end

      # title
      @title = title.gsub(/^\#\s/, '').strip if title

      # content
      @body = body.join("").strip
    end
  end
  
  
  # A callback to see if this document should be added to the list
  def valid?
    true
  end
  
  
  # Documents are the same if their IDs are the same
  def == (rhs)
    @slug == rhs.slug
  end
  
  
  # Sort by filename
  def <=> (rhs)
    @filename <=> rhs.filename
  end
  
  
  # Stringify this document
  def to_s
    title
  end
  
  
  protected    
    
    # Grab the @path with a slash if needed
    def self.path_with_slash
      files_path = File.expand_path(@path)
      files_path += '/' unless files_path.end_with? '/'
      files_path
    end
    
    
    # Find a document by its slug
    def self.find_by_slug (slug)
      filename = path_with_slash + slug + '.text'
      if File.exists? filename
        document = new(:filename => filename)
        document if document.valid?
      end
    end
    
    
    # Load the any documents in the files path
    def self.prepare (args = {})
      if @documents.nil? or args[:force]
        files_path = path_with_slash
        
        @documents = []
        @categorised = {}

        # find some documents
        Dir.glob(["#{files_path}*", "#{files_path}*/*"]).each do |filename|
          if filename.split('.').last == 'text'
            document = new(:filename => filename)
            if document.valid?
              @documents << document
              @categorised[document.category] ||= []
              @categorised[document.category] << document
            end
          end
        end
        @documents.sort!
      end
      @documents
    end
end