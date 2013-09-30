jQuery.ajaxSetup( {
	'beforeSend': function( xhr ) {
  		xhr.setRequestHeader( 'Accept', 'text/javascript' );
  		xhr.setRequestHeader( 'X-CSRF-Token', $( 'meta[name=csrf-token]' ).attr( 'content' ) );
	},
   	'complete': function() {
	}
} );

jQuery(document).ready(function() {
var notifications = {}
  	function notifyMe(){
  		$.ajax({
			type	:   "GET",
	   		url		: 	'/blog/get_updates'
	   	}).done(function(data) {
	   		 setNotifications(data);
			 //console.log("Pending Invites = " + data.pending_invites + '\n' + "Unread Message Count = " + data.unread_message_count)
	    }).fail(function(){
	    	notifyMe();
	    	 //alert('Error retrieving data!');
	    });
  	}
	
  	notifyMe();
  	
	// setInterval( function() {
  		// notifyMe();
	// }, 10000);
	
	
	function setNotifications(data){
		unread_message_notifier = $('#notifier').find('#unread-notification').find('span.badge');
		if(data.unread_message.count > 0){
   		 	$(unread_message_notifier).text(data.unread_message.count);
   		 	buildMessageNotifier(data.unread_message)
		}else{
   		 	$(unread_message_notifier).text('');
		};
		
		pending_invites_notifier = $('#notifier').find('#friend-notification').find('span.badge');
		if(data.friend_request.count > 0){
   		 	$(pending_invites_notifier).text(data.friend_request.count);
		}else{
   		 	$(pending_invites_notifier).text('');
		};		
	};
	
	function buildMessageNotifier(unread){
		dropDownMenu = '<ul class="dropdown-menu extended inbox">' +
					   '<li><p>' + unread.notification + '</p></li>' +
					   buildMessageRow(unread.messages) +
					   '<li class="external">' +
                        '<a href="inbox.html">See all messages <i class="m-icon-swapright"></i></a>' +
                     	'</li>' +
                     	'</ul>';
 		$('#notifier').find('#unread-notification').append(dropDownMenu);
    }
	
	function buildMessageRow(unread_messages){
		message_row = '';
		$.each(unread_messages, function(index, val){
		message_row +=	'<li><a href="'+ val.url  +'">' +
                        '<span class="photo"><img src="'+ val.cover +'" alt=""></span>' +
                        '<span class="subject">' +
                        '<span class="from">'+ val.sender +'</span>' +
                        '<span class="time">'+ val.sent_at +'</span>' +
                        '<span class="message">' + val.content + '</span>' +
                        '</a>' +
                     '</li>';
        });
        return message_row;
	}

	
});