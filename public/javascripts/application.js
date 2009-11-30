// This file is automatically included by javascript_include_tag :defaults

// global boolean to mark if drag selection is enabled
var isDragSelectionEnabled = false;

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

	// observers table for click - uses delegation for speed
	if ($('resource-calendar')) {
		$('resource-calendar').observe("click", cellClicked);
		$('resource-calendar').observe("mouseover", hoverDay);
		$('resource-calendar').observe("mouseout", clearHover);
		$('resource-calendar').observe("mousedown", enableDragSelection);
		$('resource-calendar').observe("mouseup", disableDragSelection);
	}
});

