//-----------------------------------------------------------------------------
// app/assets/javascripts/tasks.js
//-----------------------------------------------------------------------------

//--
// Add the jQuery datepicker to an element
//
jQuery.fn.addDatepicker = function() {
	this.datepicker();
	
	return this;
}

//**** 
// Initialize the summernote editor for all of the tasks
//
jQuery.fn.initTaskEditor = function() {
  console.log("[TASK]: initTaskEditor()");
  
  $(this).each(function(){
    $(this).summernote({
      toolbar:  false
    });
  });
  
  return this;
}

/**
 * Initialize the summernote editor for notes, which includes the toolbar
 */
jQuery.fn.initNoteEditor = function() {
  console.log("[TASK]: initTaskEditor()");
  
  $(this).each(function(){
    $(this).summernote({
      height:  100,
      toolbar: [
          // [groupName, [list of button]]
          ['style',     ['bold', 'italic', 'underline', 'clear']],
          //** ['font',      ['strikethrough']],
          ['fontsize',  ['fontsize']],
          //** ['color',     ['color']],
          ['para',      ['ul', 'ol', 'paragraph']],
          ['link',      ['link']]
        ],
        placeholder: 'Enter description...'
    });
  });
  
  return this;
}

/**
 * Clear the task form after adding a new task
 */
jQuery.fn.clearTaskForm = function() {
  console.log("[clearTaskForm]: Called method to clear the task form");

  //** this.find( '#task_description'  ).val('').focus();
  this.find( '[data-provider="summernote"]' ).summernote('reset');
 	this.find( '#task_due_text'               ).val('');
 	this.find( '.form-group'                  ).removeClass('has-error');
  
  return this;
}

jQuery.fn.clearEditModalContents = function() {
  console.log("[clearEditModalContents]: entered")
  
  // Remove the model form, so there are not duplicates
  $("div#task-modal-body").find("#edit-task-form").remove();
  
  return this;
}

//-----------------------------------------------------------------------------
// main()
//-----------------------------------------------------------------------------
$(document).ready(function() {
  // Turn on the datepicker
  $( ".datepicker" ).datepicker();
  
  $('[data-provider="summernote"]').initTaskEditor();
  $('[data-provider="summernote-notes"]').initNoteEditor();
  
  /**
   * Render the new task form in the modal window. Prefill the description
   * with a link.
   */
  $('#addTaskModal').on('show.bs.modal', function (event) {
    var link      = $(event.relatedTarget);
    var desc      = link.data("task-description");
    var params    = jQuery.param( { task: { description: desc } } );
    var url       = '/' + 'tasks' + '/' + 'new' + '?' + params;

    $.getScript(url, function( data, textStatus, jqxhr ) {
        console.log( data );          // Data returned
        console.log( textStatus );    // Success
        console.log( jqxhr.status );  // 200
        console.log( "Load was performed." );
    });

    return;
  });
  
  /**
   * Handle the edit modal card close event by calling the function
   * to clear the modal window contents before closing the modal window.
   */
  $('#addTaskModal').on('hide.bs.modal', function(event) {
    $(this).clearEditModalContents();
  });
});