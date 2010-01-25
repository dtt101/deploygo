// global boolean to mark if drag selection is enabled
var isDragSelectionEnabled = false;

// handles change of selected project - sets cookie to remember choice
function handleProjectChange(e) {
	var project_selection = Element.extend(e.element());
	var c = new Cookies();
	c.set('deploygo_project_selection', project_selection.value);
}

// toggle filters visibility
function toggleFilters(e) {
	Event.stop(e);
	$('filter-select').toggleClassName('filters-hidden', 'filters-visible');
}
// shows help message
function showHelp(e) {
	var mousex = e.pointerX();
	var mousey = e.pointerY();
	var h = $('button-help').getHeight();
	var w = $('button-help').getWidth();
	var ypos = mousey + 14;
	var xpos = (mousex - w) + 15;
	$('button-help').show();
	$('button-help').setStyle({
	  'top': ypos + 'px',
	  'left': xpos  + 'px'
	});
}
function hideHelp(e) {
	$('button-help').hide();	
}

// handles selecting a date from the calendar
function navigateToDate(dateString) {
	// parse date and move URL 2009/11/10 10th November 2009
	var theDate = new Date(dateString);
	window.location.href = '/' + theDate.getFullYear() + '/' + (theDate.getMonth() + 1) + '/' + theDate.getDate();
}

// creates a single allocation from a click on an empty cell
function createAllocationOnDay(resource_id, allocation_date, project_id, token) {
	var allocations = new Array();
	allocation = {'resource_id':resource_id, 'allocation_date':allocation_date, 'project_id':project_id};
	allocations.push(allocation);
	// send allocations to server as JSON
	new Ajax.Request('/time/create', {
		asynchronous:true, 
		evalScripts:true, 
		parameters: {
			'authenticity_token':token,
			'allocations':allocations.toJSON()
		}
	});
}

// update project name and days in select project drop-down
function updateProjectOptionText(msg, projid) {
	$$('#allocation_project_id option').each(function(elem) {
    	if (elem.value == projid) {
		    elem.text = msg;
		}
	});
}

// this is activated from the link inside the project
function toggleAllocationSelection(elm) {
    Element.extend(elm);
	celly = Element.extend(elm.ancestors()[0]);
	celly.toggleClassName('cell-selected');
}

// deselect all allocations
function deselectAllocations() {
	$$('#resource-calendar td.cell-selected').each(function(elem) {	
		elem.removeClassName('cell-selected');
		elem.removeClassName('cell-hover');
	});
}

// deletes allocations from selected cells
function deleteSelectedAllocations(token) {
	var allocations = new Array();
	$$('#resource-calendar td.cell-selected div').each(function(elm) {	
		project = elm.identify();
		// get ids from id of div
		allocation_id = project.split('_')[1];
		allocation = {'allocation_id':allocation_id};
		allocations.push(allocation);
	});
	// send allocations to server as JSON
	new Ajax.Request('/time/destroy', {
		asynchronous:true, 
		evalScripts:true, 
		parameters: {
			'authenticity_token':token,
			'allocations':allocations.toJSON()
		}
	});
}

// makes allocations for each selected cell
function doSelectedAllocations(token) {
	var allocations = new Array();
	$$('#resource-calendar td.cell-selected').each(function(elm) {	
		day = elm.identify();
		// get value from id
		dayvals = day.split('_');
		if (dayvals[0] == "day") {
            Element.extend(elm);
			// only allocate for empty days
			if (elm.childElements().length == 0) {
				resource_id = dayvals[1];
				allocation_date = dayvals[2];
				project_id = $('allocation_project_id').value;
				allocation = {'resource_id':resource_id, 'allocation_date':allocation_date, 'project_id':project_id};
				allocations.push(allocation);
			}
		}
	});
	// send allocations to server as JSON
	new Ajax.Request('/time/create', {
		asynchronous:true, 
		evalScripts:true, 
		parameters: {
			'authenticity_token':token,
			'allocations':allocations.toJSON()
		}
	});
}

// code run when window loads
document.observe("dom:loaded", function() {

	notificationHide = function(e) {
		Effect.SlideUp('notifications', { duration: 0.5, delay: 3 });
	}
	
	// notifications - test for id notice or id warning
	if (($('notice') != undefined || $('warning') != undefined) && $('notifications') != undefined) {
		notificationHide();	
	}
	
	cellClicked = function(e) {
		day = e.element().identify();
		// get value from id
		dayvals = day.split('_');
		if (dayvals[0] == "day") {
            cell = e.element();
            Element.extend(cell);
			// if cell has class cell-selected deselect
			if (cell.hasClassName('cell-selected')) {
				cell.removeClassName('cell-selected');
			} else if (e.element().childElements().length == 0) {
		      	// else if no allocation allocate
				resource_id = dayvals[1];
				allocation_date = dayvals[2];
				token = $('tracker').value;
				project_id = $('allocation_project_id').value;
				createAllocationOnDay(resource_id, allocation_date, project_id, token);
			} else {
				// has allocation - unselected - so select
				cell.addClassName('cell-selected');
			}
		}
	}

    hoverDay = function(e) {
		itemId = e.element().identify();
		cell = undefined;
		// get value from id
		itemvals = itemId.split('_');
		if (itemvals[0] == "day") {
            cell = e.element();
            Element.extend(cell);
        } else if (itemvals[0] == "allocation") {
		    elm = Element.extend(e.element());
			cell = Element.extend(elm.ancestors()[0]);
		}
		if (cell != undefined) {
			if (isDragSelectionEnabled) {
				cell.addClassName('cell-selected');
				cell.removeClassName('cell-hover');
			} else {
				cell.addClassName('cell-hover');
			}
		}
    }

	clearHover = function(e) {
		hoverDay(e);
		// the above makes sure that cell-selected is added
		// then, because of mouseout being odd make sure cell-hover is removed
		itemId = e.element().identify();
		cell = undefined;
		// get value from id
		itemvals = itemId.split('_');
		if (itemvals[0] == "day") {
            cell = e.element();
            Element.extend(cell);
        } else if (itemvals[0] == "allocation") {
		    elm = Element.extend(e.element());
			cell = Element.extend(elm.ancestors()[0]);
		}
		if (cell != undefined) {
			if (!isDragSelectionEnabled) {
				cell.removeClassName('cell-hover');
			}
		}		
	}

	enableDragSelection = function(e) {
		isDragSelectionEnabled = true;
	}
	
	disableDragSelection = function(e) {
		isDragSelectionEnabled = false;
	}	

	// check for selected project
	var c = new Cookies();
	if (c.get('deploygo_project_selection')) {
		var project_select = $('allocation_project_id');
		if (project_select) {
			project_select.value = c.get('deploygo_project_selection');
		}
	}

	// observers table for click - uses delegation for speed
	if ($('resource-calendar')) {
		$('resource-calendar').observe("click", cellClicked);
		$('resource-calendar').observe("mouseover", hoverDay);
		$('resource-calendar').observe("mouseout", clearHover);
		$('resource-calendar').observe("mousedown", enableDragSelection);
		$('resource-calendar').observe("mouseup", disableDragSelection);
		$('help-link').observe("mouseover", showHelp);
		$('help-link').observe("mouseout", hideHelp);
		$('show-filters').observe("click", toggleFilters);
		$('filter-select').observe("mouseleave", toggleFilters);
		$('resource-calendar').observe("mouseout", clearHover);
		$('allocation_project_id').observe("change", handleProjectChange);
	}
});

