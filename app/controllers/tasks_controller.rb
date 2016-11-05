#------------------------------------------------------------------------------
# app/controllers/tasks_controller.rb
#------------------------------------------------------------------------------
class TasksController < ApplicationController
  
  before_action   :authenticate_user!
  
  def index
    logger.debug("[TASKS]: index, params=[#{params.inspect}]")
    
    @user   = current_user
    @task   = @user.tasks.new
    @tasks  = @user.tasks.all
  end
  
  def new
    logger.debug("[TASKS]: new, params=[#{params.inspect}]")
    
    @user   = current_user
    @task   = @user.tasks.new(task_params)
    
    h       = get_new_task_params
    fred    = @user.tasks.new(task_params)
    logger.debug("[TASKS]: get_new_task_params(), class= #{h.class}, hash= #{h.inspect}")
    logger.debug("[TASKS]: fred= #{fred.inspect}")
    ## @task   = @user.tasks.new(get_new_task_params)
    
    respond_to do |format|
      format.html { render 'new' }
      format.js   { render 'new' }
    end
  end
  
  def create
    logger.debug("[TASKS]: create, params=[#{params.inspect}]")
    
    if is_cancelled?
      logger.debug  "[TASKS]: user cancelled the request, do NOT create task"
      
      respond_to do |format|
        format.html { redirect_to   tasks_path  }
        format.js   { render        'cancel'    }
      end
      
      return
    end
    
    @user   = current_user
    @task   = @user.tasks.new(task_params)
    
    if @task.save
      logger.info   "[TASKS]: saved tasks, with description= #{@task.description}"
      
      #########################################################################
      # TODO: 11/03/2016
      # - I NEED TO CREATE A create.js.erb TEMPLATE FILE THAT WILL CLEAR THE
      #   FORM AND THEN REDRAW THE LIST OF TASKS. I'VE TAKEN THE EASY WAY
      #   BY REDIRECTING TO THE TASKS#INDEX VIEW.
      #########################################################################
      respond_to do |format|
        format.html { redirect_to   tasks_path      }
        format.js   { render        'create'        }
      end
      
    else
      logger.error  "[TASKS]: Failed to save the task, errors are #{@task.errors.messages.inspect}"

      respond_to do |format|
        format.html { render        'new'           }
        format.js   { render        'create_error'  }
      end      
    end
  end
  
  def edit
    logger.debug("[TASKS]: edit, params=[#{params.inspect}]")
    
    @user   = current_user
    @task   = @user.tasks.find(params[:id])
    
    respond_to do |format|
      format.html { render 'edit' }
      format.js   { render 'edit' }
    end
  end
  
  def update
    logger.debug("[TASKS]: update, params=[#{params.inspect}]")
    
    if is_cancelled?
      logger.debug  "[TASKS]: user cancelled the request, do NOT update task"
      redirect_to   tasks_path
      return
    end
    
    @user = current_user
    @task = @user.tasks.find(params[:id])
    
    if @task.update(task_params)
      logger.debug  "[TASKS]: successfully updated task w/ id=#{@task.id}"
      respond_to do |format|
        format.html { redirect_to   tasks_path  }
        format.js   { render        'update'    }
      end
    else
      logger.error  "[TASKS]: failed to update task w/ id=#{@task.id}, errors= #{@task.errors.messages}"
      respond_to do |format|
        format.html { render        'edit'          }
        format.js   { render        'update_error'  }
      end
    end
  end
  
  def destroy
    logger.debug("[TASKS]: destroy, params=[#{params.inspect}]")
    
    @user = current_user
    @task = @user.tasks.destroy(params[:id])
    
    respond_to do |format|
      format.html { redirect_to :back     }
      ## format.js   { render      'destroy' } 
    end
  end
  
  #----------------------------------------------------------------------------
  # Private
  #----------------------------------------------------------------------------
  private
  
    ##
    # Strong parameters
    #
    def task_params
      params.require(:task).permit(:description, :due_text, :complete, :user_id)
    end
    
    ##
    # Determine if there is a prefilled task description for automatically
    # generated tasks
    #
    def get_new_task_params
      params["task"].blank? ? '' : params["task"] 
    end
    
    ##
    # Check to see if user cancelled request
    #
    def is_cancelled?
      return true   if params[:commit] == "cancel"
      return false
    end
  
end # end of class TasksController
