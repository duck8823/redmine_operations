$(function(){
	$('.editable').each(function() {
		var this$ = $(this);

		var width = function() {
			if (this$.hasClass('operation_master')) {
				var issue$ = $('div.issue');
				return issue$.width() - 2 * issue$.css('padding').replace('px', '');
			} else {
				var parent = this$.parent();
				return parent.width() - 2;
			}
		};

		this$.editable({
			name: this$.data('name'),
			id: this$.data('id'),
			width: width()
		});
	});

	$('.save').on('click', function() {
		$(this).parent('form').submit();
	});
	$('.delete-task').on('click', function() {
		$(this).parent('div').find('table tr').each(function(){
			var tr$ = $(this);
			var editCheck = tr$.find('.edit_check');
			if (editCheck != null && editCheck.prop('checked')) {
				tr$.remove();
			}
		});
	});
	$('.add-task').on('click', function() {
		var this$ = $(this);
		var operation_master = {id : $(this).data('ops-id')};
		$.ajax({
			type: 'POST',
			url : window.location.href + '/task/add',
			data : {
				operation_master : operation_master
			},
			success: function(response) {
				var task_master = response.task_master;
				var tr =
					"<tr data-task-id='" + task_master.id + "'>" +
					"<td class='checkbox'>" +
					"<input type='checkbox' class='edit_check' />" +
					"</td>" +
					"<td style='width: 30px'>" +
					task_master.id +
					"<input type='hidden' name='task_master[" + task_master.id + "][id]' value='" + task_master.id + "' />" +
					"</td>" +
					"<td style='text-align: left'>" +
					"<span class='editable' data-id='ops"+ operation_master.id + "_task" + task_master.id + "' data-name='task_master[" + task_master.id + "][content]'></span>" +
					"</td>" +
					"</tr>";

				this$.parent('td').parent('tr').before(tr);

				$("tr[data-task-id='" + task_master.id + "']").find('.editable').each(function(){
					$(this).editable({
						name: $(this).data('name'),
						id: $(this).data('id'),
						width: $(this).parent().width() - 2
					});
				});
			}
		});
	});
});