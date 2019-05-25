desc "run"
task :run do
  sh 'bundle exec rackup -p 3000'
end

desc "serve (using py)"
task :serve do
  sh './server.sh'
end


task default: :run
