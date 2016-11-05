#------------------------------------------------------------------------------
# app/controllers/tasks_controller.rb
#------------------------------------------------------------------------------
class NotesController < ApplicationController
  before_action   :authenticate_user!
  
  def index
    logger.debug("[NOTES]: index, params=[#{params.inspect}]")
    
    @user   = current_user
    @note   = @user.notes.new
    @notes  = @user.notes.all
  end
  
  def new
    logger.debug("[NOTES]: new, params=[#{params.inspect}]")
    
    @user   = current_user
    @note   = @user.notes.new
  end
  
  def create
    logger.debug("[NOTES]: create, params=[#{params.inspect}]")
    
    @user   = current_user
    @note   = @user.notes.new(note_params)
    
    if @note.save
      logger.info   "[NOTES]: saved notes, with title= #{@note.title}"
      
      respond_to do |format|
        format.html { redirect_to   notes_path      }
        format.js   { render        'create'        }
      end
      
    else
      logger.error  "[TASKS]: Failed to save the note, errors are #{@note.errors.messages.inspect}"

      respond_to do |format|
        format.html { render        'new'           }
        format.js   { render        'create_error'  }
      end      
    end
  end
  
  def destroy
    logger.debug("[NOTES]: destroy, params=[#{params.inspect}]")
    
    @user = current_user
    @note = @user.notes.destroy(params[:id])
    
    respond_to do |format|
      format.html { redirect_to :back     }
      ## format.js   { render      'destroy' } 
    end
  end
  
  #----------------------------------------------------------------------------
  # Private
  #----------------------------------------------------------------------------
  def note_params
    params.require(:note).permit(:title, :description, :user_id)
  end
  
end # end of class NotesController
