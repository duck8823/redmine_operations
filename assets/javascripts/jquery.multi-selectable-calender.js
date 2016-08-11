var dt = new Date();
var currentYear = dt.getFullYear();
var currentMonth = dt.getMonth() + 1;
var selectedDate = [];

$(function() {
	$('.datepicker').each(function () {
		var op_id = $(this).data('operation-id');
		selectedDate[op_id] = [];
		$(this).data('date').forEach(function (date) {
			selectedDate[op_id][date] = 1
		});

		var datepicker$ = $(this);
		datepicker$.datepicker({
			dateFormat: 'yy-mm-dd',

			onSelect: function (date) {
				if (selectedDate[op_id][date] == null) {
					selectedDate[op_id][date] = 1;
				} else {
					delete selectedDate[op_id][date];
				}

				setTimeout(function () {
					for (var i in selectedDate[op_id]) {
						var data = i.split('-');
						if (parseInt(data[0]) !== currentYear || parseInt(data[1]) !== currentMonth) {
							continue
						}
						$('[data-operation-id="' + op_id + '"] .ui-datepicker-calendar a').each(function () {
							var $this = $(this);
							if (parseInt($this.text()) === parseInt(data[2])) {
								$this.addClass('ui-state-scheduled');
							}
						});
					}
				}, 10);

				datepicker$.find("input").val(Object.keys(selectedDate[op_id]));
			},

			onChangeMonthYear: function (year, month) {
				currentYear = year;
				currentMonth = month;

				setTimeout(function () {
					for (var i in selectedDate[op_id]) {
						var data = i.split('-');
						if (parseInt(data[0]) !== currentYear || parseInt(data[1]) !== currentMonth) {
							continue
						}
						$('[data-operation-id="' + op_id + '"] .ui-datepicker-calendar a').each(function () {
							var $this = $(this);
							if (parseInt($this.text()) === parseInt(data[2])) {
								$this.addClass('ui-state-scheduled');
							}
						});
					}
				}, 10);
			}
		});

		setTimeout(function () {
			for (var i in selectedDate[op_id]) {
				var data = i.split('-');
				if (parseInt(data[0]) !== currentYear || parseInt(data[1]) !== currentMonth) {
					continue
				}
				$('[data-operation-id="' + op_id + '"] .ui-datepicker-calendar a').each(function () {
					var $this = $(this);
					if (parseInt($this.text()) === parseInt(data[2])) {
						$this.addClass('ui-state-scheduled');
					}
				});
			}
		}, 10);
		datepicker$.find("input").val(Object.keys(selectedDate[op_id]));
	}) ;
});