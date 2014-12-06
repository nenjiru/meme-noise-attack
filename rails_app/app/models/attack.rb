class Attack < ActiveRecord::Base
  enum :status => {
    :already   => 'already',
    :still_not => 'still_not'
  }
end
