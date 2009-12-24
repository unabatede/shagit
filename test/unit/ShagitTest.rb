require 'test/unit'
require '../../lib/shagit'

class ShagitTest < Test::Unit::TestCase
    @@repo_name = 'test'

    def test_create
      puts "Creating new repository"
      Shagit.create_repo(@@repo_name)
      repository_created = FileTest.directory?("#{@@repo_name}.git")
      assert(repository_created, 'repository could not be created.')
    end
    
    def test_initialize
      Shagit.create_repo(@@repo_name)
      puts "Initializing repository"
      shagit = Shagit.new
      assert_equal(1, shagit.repositories.length, 'repository not initialized properly')
    end

    def test_gc_auto
      puts "Optimizing repository for #{@@repo_name}"
      Shagit.create_repo(@@repo_name)
      test_repo = Repo.new("#{@@repo_name}.git")
      assert(test_repo.gc_auto, 'could not auto optimize repository')
    end

    def test_delete
      Shagit.create_repo(@@repo_name)
      puts "Deleting repository"
      result = Shagit.delete_repo!("#{@@repo_name}.git")
      assert(result, 'repository could not be deleted')
    end

    def teardown
      `rm -rf #{@@repo_name}.git`
    end
end
