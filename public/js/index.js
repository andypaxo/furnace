$(function() {
	$('#view_combined').click(function(e) {
		var combined_data = {
			github: {
				user: $('#github_user').val(),
				auth: $('#github_auth').val()
			},
			cc: $.map($('.cc_form'), function(e) {
				return {
					server: $(e).find('#cc_server').val(),
					user: $(e).find('#cc_user').val(),
					pass: $(e).find('#cc_pass').val()
				}
			})
		};
		$('#combined_data').val(JSON.stringify(combined_data));
	});
	
	$('#cc_add').click(function() {
		$('.cc_form').last().clone().insertBefore($(this));
	});
});