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

function ignore_posting(pid) {
	$.ajax({
		type: "POST",
		url: '/postings/' + pid + '/ignore',
		cache: false,
		success: function(){
			$('#posting_' + pid).slideUp('slow', function() {$(this).remove();});
		}
	});

	return false;
};
