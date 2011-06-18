// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function destroy_task(tid) {
	$.ajax({
		type: "DELETE",
		url: '/tasks/' + tid,
		cache: false,
		success: function(){
			$('#task_' + tid).slideUp('slow', function() {$(this).remove();});
		}
	});

	return false;
};
