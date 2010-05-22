require 'test/unit'

Dir.glob('test/test_*.rb').each do |filename|
	require filename if filename != __FILE__
end
