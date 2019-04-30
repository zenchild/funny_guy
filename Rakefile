require "bundler/gem_tasks"
require "rake/testtask"
require "funny_guy"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Tell me a joke using a 1st order Markov Chain"
task :tell_me_a_1st_order_joke do
  puts FunnyGuy::Generator.tell_me_a_joke(1)
end

desc "Tell me a joke using a 2nd order Markov Chain"
task :tell_me_a_2nd_order_joke do
  puts FunnyGuy::Generator.tell_me_a_joke(2)
end

desc "Clear Jokes DB and Cached Chains"
task :clear_db do
  dbdir = File.expand_path("#{__dir__}/db")
  puts "Clearing db: #{dbdir}"
  sh "rm -rf #{dbdir}"
end

task default: :tell_me_a_1st_order_joke