###
### Extends activerecord with model#validate!
### This throws the same exception like it would on save!
###
### License: none?
### Author: gizmore@wechall.net
###
### Tested with:
### [+] ActiveRecord 4.1.1
###
###
module ActiveRecord
  class Base
    def validate!
      raise(RecordInvalid.new(self)) if invalid?
      true
    end
  end
end
