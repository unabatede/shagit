$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../../lib"))

require 'test/unit'
require 'lib/shagit'

class ShagitTest < Test::Unit::TestCase
    @@repo_name = 'unit-test.git'
    $working_dir = '.'

    def test_00_create
      puts "Creating new repository"
      Shagit.create_repo(@@repo_name)
      repository_created = FileTest.directory?("#{@@repo_name}")
      assert(repository_created, 'repository could not be created.')
    end

    def test_01_load_config
      puts "Loading configuration file"
      config_file = 'config.yml'
      require 'lib/helpers/helpers'
      load_config(config_file)
      config_data = ConfigInfo.instance
      assert_equal(".", config_data.working_dir, 'loading configuration file failed')

    end
    
    def test_02_initialize
      Shagit.create_repo(@@repo_name)
      puts "Initializing repository"
      shagit = Shagit.new
      assert_equal(1, shagit.repositories.length, 'repository not initialized properly')
    end

    def test_03_gc_auto
      puts "Optimizing repository for #{@@repo_name}"
      Shagit.create_repo(@@repo_name)
      test_repo = Repo.new("#{@@repo_name}")
      assert(test_repo.gc_auto, 'could not auto optimize repository')
    end

    def test_04_delete
      Shagit.create_repo(@@repo_name)
      puts "Deleting repository"
      result = Shagit.delete_repo!("#{@@repo_name}")
      assert(result, 'repository could not be deleted')
    end

    def teardown
      `rm -rf #{@@repo_name}`
    end
end
