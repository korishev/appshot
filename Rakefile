#!/usr/bin/env rake
require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

task :default => :spec

task :spec => %w(spec:unit)

namespace :spec do
  desc "Run specs with code coverage"
  RSpec::Core::RakeTask.new(:cov) do |spec|
    spec.rspec_opts = "--format nested --format SpecCoverage"
  end

  desc "Run unit specs"
  RSpec::Core::RakeTask.new(:unit) do |spec|
    spec.pattern = "spec/**/*_spec.rb"
    spec.ruby_opts = "-w"
  end
end
