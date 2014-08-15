###
### Extends ActiveModels with a global cache table.
### This is not meant for performance; It has overhead 
### It shall just make sure each instance queried from the db shares the same memory address.
###
### Example:
### class Foo < ActiveRecord::Base
###   with_global_orm_mapping
###   def should_cache?; true; end  # You can filter out here if wanted to cache the row
###
### License: none?
### Author: gizmore@wechall.net
### Tested with:
### [+] ActiveRecord-4.1.1
###
###
module ActiveRecord

  class Base
    def self.with_global_orm_mapping
      class_eval do |cl|
        cl.class_variable_set('@@CACHE', {}) unless cl.class_variable_defined?('@@CACHE')
        def global_cache_table(record)
          c = self.class.class_variable_get('@@CACHE')
          c[record.id] ||= record if record.should_cache?
          c[record.id] || record
        end
        def self.global_cache
          self.class.class_variable_get('@@CACHE')
        end
        def global_cache_add
          global_cache_table(self)
        end
        def global_cache_remove
          self.class.class_variable_get('@@CACHE').delete(self.id)
        end
      end
    end
  end

  class Relation
    
    alias :original_exec_queries :exec_queries
    
    def exec_queries
      new_records = []
      original_exec_queries.each do |record|
        break unless record.respond_to? :global_cache_table
        new_records.push(record.global_cache_table(record))
      end
      @records = new_records unless new_records.empty?
      @records
    end
    
  end
end
