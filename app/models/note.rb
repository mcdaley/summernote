#------------------------------------------------------------------------------
# app/models/note.rb
#------------------------------------------------------------------------------
class Note < ActiveRecord::Base
  belongs_to    :user
  
  validates     :title,         presence:   true,   length: { minimum: 2 }
  validates     :description,   presence:   true,   length: { minimum: 2 }
end
