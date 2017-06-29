namespace :elasticsearch do
  task :create_index do
    Article.__elasticsearch__.create_index!(force: true)
  end

  task :delete_index do
    Article.__elasticsearch__.delete_index!
  end

  task :import do
    Article.__elasticsearch__.import
  end
end
