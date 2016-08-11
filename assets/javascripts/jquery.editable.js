/**
 * クリックするとinputタグが表示されるjQueryプラグイン
 */
$.fn.editable = function(options, callback) {
	$(this).each(function(){
		var settings = $.extend({
			width : 500
		}, options);
		if (!settings.name) {
			throw new Error('options should have name');
		}

		var editable = $(this);
		editable.css({
			'text-decoration' : 'underline',
			'color' : '#169',
			'cursor' : 'pointer'
		});
		var input = function() {
			if (editable.hasClass('inline')) {
				return "<input type='text' id='" + settings.id + "' name='" + settings.name + "' style='width: " + settings.width + "px' hidden='hidden' value='" + editable.text() + "' />";
			} else {
				return "<textarea id='" + settings.id + "' name='" + settings.name + "' style='width: " + settings.width + "px' hidden='hidden' >" +
					editable.text() +
					"</textarea>"
			}
		};
		editable.after(
			input() +
			"<span class='icon icon-edit' data-for='" + settings.id + "'></span>"
		);
		var hiddenElem = $("[id='" + settings.id + "']");
		var editIcon   = $(".icon-edit[data-for='" + settings.id + "']");
		editIcon.css({
			'cursor' : 'pointer'
		});

		editable.on('click', function() {
			hiddenElem.removeAttr('hidden');
			editable.attr('hidden', 'hidden');
			editIcon.attr('hidden', 'hidden');
		});
		editIcon.on('click', function() {
			hiddenElem.removeAttr('hidden');
			editable.attr('hidden', 'hidden');
			editIcon.attr('hidden', 'hidden');
		});
		$(document).on('click', function() {
			editable.on('click', function() {
				event.stopPropagation();
			});
			editIcon.on('click', function() {
				event.stopPropagation();
			});
			hiddenElem.on('click', function() {
				event.stopPropagation();
			});

			if (editable.text() != hiddenElem.val() && callback != undefined) {
				callback({value: hiddenElem.val()});
			}

			editable.text(hiddenElem.val());
			hiddenElem.attr('hidden', 'hidden');
			editable.removeAttr('hidden');
			editIcon.removeAttr('hidden');
		});
	});
	$(document).click();
};