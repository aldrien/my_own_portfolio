
function initialize() {
	
  var sbma_address = new google.maps.LatLng(14.786210768634037 , 120.28391065000005);
  var home_address = new google.maps.LatLng(14.794081248360648, 120.3141018); 
  
  var mapOptions = {
    zoom: 14,
    center: sbma_address,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  var image = '/assets/img/pin.png';
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  var sbma_add = '<div>'+
      				'<p><b>Web Programmer</b> @ The Advitor Lmtd. Corp. </p>'+
      				'<p>Subic Bay Freeport Zone <br /> Olongapo City, Zambales</p>'+
      			'</div>';

  var home_add = '<div>'+
      				'<p><b>Home</b></p>'+
      				'<p>Kalaklan <br /> Olongapo City, Zambales</p>'+
      			'</div>';

  var infowindow = new google.maps.InfoWindow({
      content: sbma_add
  });

  var infowindow2 = new google.maps.InfoWindow({
      content: home_add
  });	
	
  var marker = new google.maps.Marker({
      position: sbma_address,
      map: map,
      icon: image
  });
  
  	
	
	var marker1 = new google.maps.Marker({
		position: home_address,
		map: map,
		icon: image
	});

	
  google.maps.event.addListener(marker1, 'click', function() {
    infowindow2.open(map,marker1);
  });
  	
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map,marker);
  });
}

google.maps.event.addDomListener(window, 'load', initialize);



// ( function( $ ) {
	// $( document ).ready( function() {
		// var mapOptions = {
			// center: new google.maps.LatLng(14.786210768634037 , 120.28391065000005), 
			// zoom: 14,
			// disableDefaultUI: true,
			// mapTypeId: google.maps.MapTypeId.ROADMAP
		// };
// 
		// var map = new google.maps.Map( document.getElementById( 'map-canvas' ), mapOptions );
// 
		// var image = '/assets/img/pin.png';
		// var address = new google.maps.LatLng( 14.794081248360648, 120.3141018 ); 
		// var marker1 = new google.maps.Marker({
			// position: address,
			// map: map,
			// icon: image
		// });
// 
		// image = '/assets/img/pin.png';
		// address = new google.maps.LatLng( 14.786210768634037 , 120.28391065000005 );
		// var marker2 = new google.maps.Marker({
			// position: address,
			// map: map,
			// icon: image
		// });
	// });
// }(jQuery));