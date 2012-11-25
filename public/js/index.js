$(function() {
	$('#view_combined').click(function(e) {
		var combined_data = {
			github: {
				user: $('#github_user').val(),
				auth: $('#github_auth').val()
			},
			cc: {
				server: $('#cc_server').val(),
				user: $('#cc_user').val(),
				pass: $('#cc_pass').val()
			}
		};
		$('#combined_data').val(JSON.stringify(combined_data));
	});
});