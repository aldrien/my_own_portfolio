
var Calendar = function () {
    return {
        //main function to initiate the module
        init: function () {
			App.addResponsiveHandler(function () {
                Calendar.initCalendar();
            });

            $('.page-sidebar .sidebar-toggler').click(function () {
                Calendar.initCalendar();
            });
        },

        initCalendar: function () {

            if (!jQuery().fullCalendar) {
                return;
            }
            var date = new Date();
            var d = date.getDate();
            var m = date.getMonth();
            var y = date.getFullYear();

            var h = {};
            if ($('#calendar').parents(".portlet").width() <= 720) {
                $('#calendar').addClass("mobile");
                h = {
                    left: 'title, prev, next',
                    center: '',
                    right: 'today,agendaWeek,month,agendaDay'
                };
            } else {
                $('#calendar').removeClass("mobile");
                h = {
                    left: 'title',
                    center: '',
                    right: 'prev,next,today,month,agendaWeek,agendaDay'
                };
            }

            var initDrag = function (el) {
                // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
                // it doesn't need to have a start or end
                var eventObject = {
                    title: $.trim(el.text()) // use the element's text as the event title
                };
                // store the Event Object in the DOM element so we can get to it later
                el.data('eventObject', eventObject);
                // make the event draggable using jQuery UI
                el.draggable({
                    zIndex: 999,
                    revert: true, // will cause the event to go back to its
                    revertDuration: 0 //  original position after the drag
                });
                
            }

			var setEvents  = function (title, eventId) {			
				$('#schedule_tab').unbind('click');
				$('#calendar').fullCalendar('render');
				$('#calendar').fullCalendar('rerenderEvents');
				<% unless @non_schedule_events.nil? %>
					<% for ne in @non_schedule_events %>
						addEvent("<%=ne.title%>", "<%=ne.id%>");							
					<% end %>
				<% end %>
			}


            var addEvent = function (title, eventId) {
            	title = title.length == 0 ? "Untitled Event" : title;
                var html = $('<div class="external-event label" eventId="'+ eventId +'">' + title + '</div>');
                jQuery('#event_box').append(html);
                initDrag(html);
            }

            $('#external-events div.external-event').each(function () {
                initDrag($(this));
                
            });

            $('#event_add').unbind('click').click(function () {
                var title = $('#event_title').val();
                addEvent(title, 0);
                
            });
	        $('#schedule_tab').unbind('click').click(function () {
				$('#schedule_tab').unbind('click');
				$('#calendar').fullCalendar('rerenderEvents');
				<% unless @non_schedule_events.nil? %>
					<% for ne in @non_schedule_events %>
						addEvent("<%=ne.title%>", "<%=ne.id%>");							
					<% end %>
				<% end %>
	        });

            //predefined events
            //$('#event_box').html("");
			
            $('#calendar').fullCalendar('destroy'); // destroy the calendar
            $('#calendar').fullCalendar({ //re-initialize the calendar
                header: h,
                defaultView: 'agendaWeek',
                slotMinutes: 15,
                editable: true,
				disableResizing: true,				
				// dropAccept: '#droppable',
                droppable: true, // this allows things to be dropped onto the calendar !!!
                eventDrop: function (event, dayDelta, minuteDelta, allDay, revertFunc) { // this function is called when something is 	dropped
					if (!isOverlapping(event)){
						//console.log('Not Overlap')
						$('#droppable').unbind('mouseover');
						return updateEvent(event);
					}else{
						//console.log('Overlap')
						var overlap_event_time = event.start
						return date_not_available(event, dayDelta, overlap_event_time);
						revertFunc();
						$('#droppable').unbind('mouseover');											
					}					                  
                },                
				
				drop: function(date,allDay, event){
					// retrieve the dropped element's stored Event Object
                    var originalEventObject = $(this).data('eventObject');
                    // we need to copy it, so that multiple events don't have a reference to the same object
                    var copiedEventObject = $.extend({}, originalEventObject);

                    // assign it the date that was reported
                    copiedEventObject.start = date;
                    copiedEventObject.allDay = false;
					copiedEventObject.end = (date.getTime() + 3600000)/1000;;
                    copiedEventObject.className = $(this).attr("data-class");
					copiedEventObject.id = $(this).attr("eventid");
			
                    if (!isOverlapping(copiedEventObject)){
						try{
		                    $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);
							var day = copiedEventObject.start.getDate();
						    var month = copiedEventObject.start.getMonth();
						    var year = copiedEventObject.start.getFullYear();
						    var get_date = year + "-" + month + "-" + day;
						    var get_time = copiedEventObject.start.getHours();
							console.log(get_time);
							return check_availability(get_date, get_time, copiedEventObject);	
						}
						catch(err)
  						{
  							console.log('Error saving event.' + err)
  						}
					 }else{
						 revertFunc();										
					}
				},
				eventSources: [
					{
						url: '/admin/events/all-event/<%= @user.id %>',
                        backgroundColor: App.getLayoutColorCode('yellow')
                    },                    
					{
						url: '/admin/events/user-lab-event/<%= @user.id %>',
						backgroundColor: App.getLayoutColorCode('green'),
						editable: false
					},				
					{
						url: '/admin/events/coach-events/<%= @user.id %>',
						backgroundColor: App.getLayoutColorCode('grey'),
						editable: false
					},
					{
						url: '/admin/events/coach-events-under-approval/<%= @user.id %>',
						backgroundColor: App.getLayoutColorCode('yellow'),
						editable: false
					},					
					{
						url: '/admin/events/approve-events/<%= @user.id %>',
						backgroundColor: App.getLayoutColorCode('blue'),
						editable: false
					}				
				],
				loading: function(bool) 
			    {
			        if (bool)
			        {
		            	App.blockUI('#calendar');
						setTimeout(function(){
							App.unblockUI('#calendar');
							if(document.getElementById('droppable') == null) {
								$('#calendar').children('.fc-content').children().append('<div id="droppable" class="cancel_events ui-widget-header fc-day fc-widget-content fc-first" style="cursor: pointer; text-align: center;"><h4 style="cursor: pointer;">Drag & Drop Event here to cancel</h4></div>');								
							}							
						},10)	
			        }
			    },
			    //eventDragStop: function(event, jsEvent, ui, view) {
			    	// alert($('#droppable').html())
			    	// var ui_elem = $('#'+ event.id).live('click', function(){
				    	// return $(this);
				    // });
				    // var drop_elem = $('#droppable').live('mouseover', function(){
				    	// return $(this);
				    // });
				    // if (isElemOverDiv(ui, $('#cancel_events'))) {
				        // calendar.fullCalendar('removeEvents', event.id);
				    // }	
				   
				//}
			    eventDragStop: function(event, jsEvent, ui, view) {	
			    	App.blockUI('#calendar');
					setTimeout(function(){						
						App.unblockUI('#calendar');	 	
					},10);
			    	return isElemOverDiv(ui, event);
			    	$('#droppable').unbind('mouseover');			    				  	
				},
				                
            });

        }

    };

}();


var isElemOverDiv = function(ui, event) {
	// $('#droppable').droppable({
		// tolerance: 'pointer',
		// drop: function(event, ui) {
			// $('#droppable').unbind('mouseover');	
	  		// return cancel_fn(event);
		// }
	// });
	
	
	$('#droppable').mouseover(function() {
		$('#droppable').unbind('mouseover');	
	  	return cancel_fn(event);	  	
	});	  	
}

var cancel_fn = function(event){
	return $.post("/admin/events/cancel_event/<%= @user.id %>?event_id=" + event.id, {
			      event: {
					user_id: "<%= @user.id %>",
					event_id: event.id
			      }
	    	}).done(function(data) { 
	    		
		    	if(data.cancel == 'true'){
		    		
		    		$("#modal_cancel_event").modal('show');	
		    		$('#droppable').unbind('mouseover');    			    			    		
	    		}else{
	    			
	    			$("#modal_cancel_event_unable").modal('show');
	    			$('#droppable').unbind('mouseover');	
	    		}	
	    	});
}

var check_availability = function(get_date, get_time, copiedEventObject){
    return $.post("/admin/events/check_availability/<%= @user.id %>?get_date=" + get_date + "&get_time=" + get_time, {
      event: {
		user_id: "<%= @user.id %>",
		get_date: get_date
      }
    }).done(function(data) { 
	    	if(data.approved == 'true'){
	    		$('#droppable').unbind('mouseover');
    			$("#modal_not_available").modal('show');
    			// return false;
    		}else if(data.approved == 'false'){
    			$('#droppable').unbind('mouseover');
    			$("#modal_under_approval").modal('show');	
    			// return false;
    		}else{
    			$('#droppable').unbind('mouseover');
	    		$(copiedEventObject.id).remove();
	    		return createOrUpdateEvent(copiedEventObject);	    		
	    	} 	    	
    	});
};


var isOverlapping = function(event){
	//alert(event.start)
    var array = $('#calendar').fullCalendar('clientEvents');
    for(i in array){
        if(array[i].id != event.id){
            //for production
            // if (event.end >= array[i].start && event.start <= array[i].end){
	           // return true;
	        // }
	        
	        //for local
	        if(!(array[i].start >= event.end || array[i].end <= event.start)){
                return true;
            }
        }
    }
    return false;
};


var date_not_available = function(event, dayDelta, overlap_event_time){
	//alert(overlap_event_time)	
    return $.post("/admin/events/check_event_type/<%= @user.id %>?day_count=" + dayDelta + "&event_id=" + event.id + "&event_time=" + overlap_event_time, {
      event: {
      	day_move: dayDelta,
		user_id: "<%= @user.id %>"
      }
    }).done(function(data) { 
	    	//alert(data.is_approve); 
	    	if(data.message == "The time is not available"){
	    		$('#droppable').unbind('mouseover');
	    		$("#modal_not_available").modal('show');
	    		var evt = "div[eventid='"+ event.id +"']"
				$(evt).remove();
	    	}else{
	    		$('#droppable').unbind('mouseover');
	    		$("#modal_under_approval").modal('show');
	    	}
				return false;
    	});
};


var createOrUpdateEvent = function(the_event) {	
	App.blockUI('#calendar');
	setTimeout(function(){
		App.unblockUI('#calendar');
		$('#droppable').unbind('mouseover');
	 	$("#modal_add").modal('show');	 	
	},10);
	var evt = "div[eventid='"+ the_event.id +"']"
	$(evt).remove();
    return $.post("/admin/events/create-update-event/" + the_event.id + "/<%= @user.id %>", {
      event: {
        title: the_event.title,
        starts_at: "" + $.fullCalendar.formatDate(the_event.start, "dd/MM/yyyy @ h:sstt"),
        ends_at: "" + $.fullCalendar.formatDate(the_event.end, "dd/MM/yyyy @ h:sstt"),
        description: the_event.description,
		id: ""+the_event.id,
		user_id: "<%= @user.id %>",
		// is_use_lab: the_event.is_use_lab,
		// is_approve: the_event.is_approve,
		// package_id: the_event.package_id
      }
    }).done(function(){
    	$('#droppable').unbind('mouseover');
    });
  };
  
var updateEvent = function(the_event) {
	App.blockUI('#calendar');
	setTimeout(function(){
		App.unblockUI('#calendar');
		$('#droppable').unbind('mouseover');
	 	$("#modal_update").modal('show');
	},10)	
    return $.post("/admin/events/" + the_event.id, {
      event: {
        title: the_event.title,
        starts_at: "" + $.fullCalendar.formatDate(the_event.start, "dd/MM/yyyy @ h:sstt"),
        ends_at: "" + $.fullCalendar.formatDate(the_event.end, "dd/MM/yyyy @ h:sstt"),
        description: the_event.description,
		id: ""+the_event.id,
		user_id: "<%= @user.id %>",
		// is_use_lab: the_event.is_use_lab,
		// is_approve: the_event.is_approve,
		// package_id: the_event.package_id
      }
    }).done(function(){
    	$('#droppable').unbind('mouseover');
    });  
  };
  