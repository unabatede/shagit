require 'test/unit'
require '../../lib/shagit'

class ShagitTest < Test::Unit::TestCase
    def test_create
      puts "Creating new repository"
      Shagit.create_repo('test')
      repository_created = FileTest.directory?('test.git')
      assert(repository_created, 'repository could not be created.')
    end
    
    def test_initialize
      Shagit.create_repo('test')
      puts "Initializing repositories"
      shagit = Shagit.new
      assert_equal(1, shagit.repositories.length, 'repositories not initialized properly')
    end
    
    def teardown
      `rm -rf test.git`
    end
end
