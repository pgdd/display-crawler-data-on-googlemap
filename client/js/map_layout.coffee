Meteor.subscribe('markers')
Meteor.subscribe('bounds')
clickMarkerIcon = '/images/blueMarker-01.png'
currentFindMarker = undefined
currentPosMarker = undefined
geocoder = undefined
geoMarkerIcon = '/images/yellowMarker.png'
latData = undefined
lngData = undefined
map = undefined
mapClickInfoWindow = undefined
mapClickedMarker = undefined
savedMarker = undefined
savedMarkerIcon = '/images/greenMarker-01.png'
formatedAddress = undefined
address = undefined
poly = undefined
geolocationInfoWindow = undefined
currentPosMarker = undefined
cleanS = undefined
scrap = [{}]
markers = [{}]
location = [{}]
url = [{}]
country = undefined
latFactual = undefined
lonFactual = undefined
name = undefined
tel = undefined
factual_id = undefined
region = undefined
postcode = undefined
fax = undefined

Template.map.rendered = ->
  google.maps.event.addDomListener(window, 'load', initializeMap);
  # geolocation()
  initializeMap()
  determine(-73.9676818, 40.7684365)

initializeMap = ->
  geocoder = new google.maps.Geocoder()

  mapOptions =
    backgroundColor: "#AFBE48"
    zoom: 8
    minZoom: 2
  mapDiv = document.getElementById("map-canvas")
  map = new google.maps.Map(mapDiv, mapOptions)

  polyOptions =
    strokeColor: "#84BB0F"
    strokeOpacity: 0.7
    strokeWeight: 3
    editable: true
    geodesic: true

  poly = new google.maps.Polyline(polyOptions)
  poly.setMap map


  autoLoadSavedMarkers()
  geolocation()
  mapClick()

infoWindowContent = (infoWindow, contentString) ->
  infoWindow.setContent(contentString)

mapClick = ->
  google.maps.event.addListener map, "click", (event) ->
    console.log view = map.getBounds().getSouthWest().lng()
    latt = event.latLng.lat()
    long = event.latLng.lng()
    latlng = new google.maps.LatLng(latt, long)
    geocoder.geocode
      latLng: latlng
    , (results, status) ->
      if status is google.maps.GeocoderStatus.OK
       formatedAddress = results[1].formatted_address
      else
        alert "No land to pin on. Please try again."

    contentString = "<div id=\"content\">" + $('#content_source').html() +  "</div>"
    mapClickInfoWindow = new google.maps.InfoWindow(content: contentString)

    infoWindowContent(mapClickInfoWindow, contentString)

    mapClickedMarker.setMap null if mapClickedMarker
    currentFindMarker.setMap null if currentFindMarker
    mapClickedMarker = new google.maps.Marker(
      position:
        lat: latt,
        lng: long,
      map: map,
      draggable: false,
      icon : clickMarkerIcon)

    google.maps.event.addListener mapClickedMarker, "click", ->
      mapClickInfoWindow.open map, mapClickedMarker
      latData = mapClickedMarker.position.lat()
      lngData = mapClickedMarker.position.lng()

    google.maps.event.addListener mapClickInfoWindow, "domready", ->
      imageId = null
      $( "div.location" ).html("<h1>#{formatedAddress}</h1>")
      $("#saveMarker").click ->
        description = $("#content #description").val()
        Markers.insert(markerObject(latData, lngData, description, imageId, formatedAddress))
    # determine(40.766859, -73.967607)
markerObject = (latData, lngData, description, imageId, formatedAddress) ->
  {lat: latData, lng: lngData, description: description, imageId: imageId, address: formatedAddress}


autoShowBounds = () ->
   if (Meteor.isClient)
    Deps.autorun () ->
      array = Bounds.find().fetch()
      for key, object of array
        console.log key
        rectangle = new google.maps.Rectangle(
            strokeColor: "#FF0000"
            strokeOpacity: 0.8
            strokeWeight: 2
            fillColor: "#FF0000"
            fillOpacity: 0.35
            map: map
            bounds: new google.maps.LatLngBounds(new google.maps.LatLng(object.marker0[0], object.marker0[1]), new google.maps.LatLng(object.marker1[0],object.marker1[1]))
          )
# autoShowBounds()
autoLoadSavedMarkers = ->
  if (Meteor.isClient)
    Deps.autorun () ->
      array = Markers.find().fetch()
      for key, object of array
        console.log key
        latt = object.lat
        long = object.lng
        description = object.description
        address = object.adress
        Session.set("(#{latt}, #{long})", object._id)
        latlng = new google.maps.LatLng(latt, long)
        path = poly.getPath()
        path.push latlng

        savedMarker = new google.maps.Marker
          position:
            lat: latt,
            lng: long,
          map: map,
          icon : savedMarkerIcon,
          draggable: false,

        google.maps.event.addListener savedMarker, "click", (event) ->
          markerId = Session.get(event.latLng.toString())
          marker = Markers.findOne({_id: markerId})
          # if marker.imageId
          #   imgUrl = Images.findOne({_id: marker.imageId}).url()
          #   imageTag = "<img src='#{imgUrl}' />"
          contentString = "<div id=\"content\">" + "<div>Name : #{marker.name}</div>"+ "<div>Tel : #{marker.telephone}</div>" + "<div>#{marker.url}</div>" + "<div>#{marker.fax}</div>" + "<div>#{marker.factual_id}</div> + </div>"
          savedInfoWindow = new google.maps.InfoWindow(content: contentString)
          infoWindowContent(savedInfoWindow, contentString)

          savedInfoWindow.open map, this

geolocation = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition ((position) ->
      pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
      contentString = "<div id=\"content\">" + $('#content_source').html() +  "</div>"
      geolocationInfoWindow = new google.maps.InfoWindow(content: contentString)
      currentPosMarker = new google.maps.Marker
        map: map,
        position: pos,
        zoom: 8,
        icon : geoMarkerIcon,

      google.maps.event.addListener currentPosMarker, "click", ->
        geolocationInfoWindow.open map, currentPosMarker
        latt = currentPosMarker.position.lat()
        long = currentPosMarker.position.lng()
        latlng = new google.maps.LatLng(latt, long)
        geocoder.geocode
          latLng: latlng
        , (results, status) ->
          if status is google.maps.GeocoderStatus.OK
           formatedAddress = results[1].formatted_address
           console.log formatedAddress
          else
            alert "Geocoder failed due to: " + status
          $( "div.location" ).html("<h1>#{formatedAddress}</h1>")

      google.maps.event.addListener geolocationInfoWindow, "domready", ->
        $("#saveMarker").click ->
          console.log "click"
          imageId = undefined
          latData = currentPosMarker.position.lat()
          lngData = currentPosMarker.position.lng()
          description = $("#content #description").val()
          Markers.insert(markerObject(latData, lngData, description, imageId, formatedAddress))

      map.setCenter pos), ->
      handleNoGeolocation true

  else
    handleNoGeolocation false

handleNoGeolocation = (errorFlag) ->
  if errorFlag
    content = "Error: The Geolocation service failed."
  else
    content = "Error: Your browser doesn't support geolocation."
  options =
    map: map
    position: new google.maps.LatLng(60, 105)
    content: content

  map.setCenter options.position
  addMarker(position, map)

geocoding = ->
  Template.map.events
    "click button#address" : (e, t) ->
      address = document.getElementById("address").value
      geocoder.geocode
        address: address
      , (results, status) ->
        if status is google.maps.GeocoderStatus.OK
          map.setCenter results[0].geometry.location
          contentString = "<div id=\"content\">" + $('#content_source').html() +  "</div>"
          geocodingInfoWindow = new google.maps.InfoWindow(content: contentString)
          currentFindMarker.setMap null if currentFindMarker
          mapClickedMarker.setMap null if mapClickedMarker
          currentFindMarker = new google.maps.Marker(
            map: map
            draggable:true,
            position: results[0].geometry.location,
            icon : clickMarkerIcon,
          )

          google.maps.event.addListener currentFindMarker, "click", ->
            geocodingInfoWindow.open map, currentFindMarker
            latt = currentFindMarker.position.lat()
            long = currentFindMarker.position.lng()
            latlng = new google.maps.LatLng(latt, long)
            geocoder.geocode
              latLng: latlng
            , (results, status) ->
              if status is google.maps.GeocoderStatus.OK
               formatedAddress = results[1].formatted_address
               console.log formatedAddress
              else
                alert "Geocoder failed due to: " + status

              $( "div.location" ).html("<h1>#{formatedAddress}</h1>")

          google.maps.event.addListener geocodingInfoWindow, "domready", ->
            $("#saveMarker").click ->
              console.log "click"
              imageId = undefined
              latData = currentFindMarker.position.lat()
              lngData = currentFindMarker.position.lng()
              description = $("#content #description").val()
              Markers.insert(markerObject(latData, lngData, description, imageId, formatedAddress))

        else
          alert "Geocode was not successful for the following reason: " + status

      e.preventDefault()
      false
geocoding()
determine = (lat, lng) ->
  adressLatLng(lat, lng)
  for i in [0..1]
    setTimeout (->
      adressLatLng(lat, lng + 5)
      return
    ), 1000
adressLatLng = (lat, lng) ->
  latlng = new google.maps.LatLng(lat, lng)
  geocoder.geocode
    latLng: latlng
  , (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      if results[1]
        map.setZoom 11
        marker = new google.maps.Marker(
          position: latlng
          map: map
        )
        infowindow.setContent results[1].formatted_address
        formatedAddress = results[1].formatted_address
        console.log formatedAddress
        infowindow.open map, marker
    else
      alert "Geocoder failed due to: " + status
    return
  return

  # var bounds = new google.maps.LatLngBounds(
  #     new google.maps.LatLng(44.490, -78.649),
  #     new google.maps.LatLng(44.599, -78.443)
  # );

  # // Define a rectangle and set its editable property to true.
  # var rectangle = new google.maps.Rectangle({
  #   bounds: bounds,
  #   editable: true
  # });

  # rectangle.setMap(map);
