require 'acts_as_mroongable/core'

module ActsAsMroongable
end

ActiveRecord::Base.send :include, ActsAsMroongable::Core
