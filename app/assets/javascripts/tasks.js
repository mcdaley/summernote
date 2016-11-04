//-----------------------------------------------------------------------------
// app/assets/javascripts/tasks.js
//-----------------------------------------------------------------------------

/** 
 * Initialize the summernote editor for all of the tasks
 */
jQuery.fn.initTaskEditor = function() {
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
  $(this).each(function(){
    $(this).summernote({
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

//-----------------------------------------------------------------------------
// main()
//-----------------------------------------------------------------------------
$(document).ready(function() {
  // Turn on the datepicker
  $( ".datepicker" ).datepicker();
  
  $('[data-provider="summernote"').initTaskEditor();
  //** $('[data-provider="summernote"').initNoteEditor();
  
});