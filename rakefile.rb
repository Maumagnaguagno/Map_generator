require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test_mapgen.rb']
  t.verbose = true
end