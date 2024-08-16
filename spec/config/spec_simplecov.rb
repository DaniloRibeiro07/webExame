# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Job', 'app/job'
  add_group 'Db', 'db'
  add_filter '/spec/'
end
