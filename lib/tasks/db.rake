# frozen_string_literal: true

namespace :db do
  desc 'db:drop, db:create, db:migrate, db:seed'
  task refresh: :environment do
    %w[db:drop db:create db:migrate db:seed].each do |task|
      Rake::Task[task].invoke
    end
  end
end
