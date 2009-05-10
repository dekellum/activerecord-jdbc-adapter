#!/usr/bin/env jruby
require 'rubygems'

# NPE trying to use v0.9 jrake test_postgres, so make this a standalone
# test instead

gem( 'activerecord', '= 2.1.2' )
gem( 'activerecord', '= 2.1.2' )
gem( 'activerecord-jdbc-adapter', '= 0.9' )
gem( 'activerecord-jdbcpostgresql-adapter', '= 0.9' )

require 'activerecord'
require 'db/postgres'
require 'test/unit'

class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table 'urls', :id => false do |t|
      t.text :uhash, :null => false
      t.text :url,  :null => false
    end
    execute "ALTER TABLE urls ADD PRIMARY KEY (uhash)"
  end
  def self.down
    drop_table 'urls'
  end
end

class Url < ActiveRecord::Base
  set_primary_key :uhash
  #Shouldn't be needed: set_sequence_name nil
end

class PostgresNonSeqPKey < Test::Unit::TestCase
  def setup
    CreateUrls.up
  end

  def teardown
    CreateUrls.down
  end

  def test_create
    url = Url.create! do |u|
      u.uhash = 'uhash'
      u.url = 'http://url'
    end
    assert_equal( 'uhash', url.uhash )
  end
end
