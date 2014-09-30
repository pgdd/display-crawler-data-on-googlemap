uuuRl = undefined
# val = 0 - (lon1 - lon0)
valY = undefined
@arrayOfObj = []
urlE = undefined
@val = 0.003
# val = undefined
isOdd = (num) ->
 console.log num % 2

markerObject = (latData, lngData, name, tel, factual_id, region, postcode, fax, url, yelp) ->
  {lat: latData, lng: lngData, name: name, tel: tel, factual_id: factual_id, region: region, postcode: postcode, fax: fax, url: url, yelp: yelp}

lat0 = undefined
lon0 = undefined
lat1 = undefined
lon1 = undefined
factualCrawl = (lonN, latN, lonNn, latNn, latData, lngData) ->
  console.log 'factualCrawl'
    # test define center of a c
  lat1 = latN
  lon1 = lonN
  lat2 = latNn
  lon2 = lonNn
  console.log lon2 - lon1
  console.log lat2 - lat1
  lat3 = undefined
  lon3 = undefined
  dLon = undefined
  dLat = undefined
  dLon = undefined
  R = undefined
  a = undefined
  c = undefined
  d = undefined
  brng = undefined
  Bx = undefined
  By = undefined
  marker = undefined
  markeru = undefined

  toRad = (Value) ->
    Value * Math.PI / 180

  bearing = () ->
    y = Math.sin(dLon) * Math.cos(lat2)
    x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon)
    brng = toRad(Math.atan2(y, x))
    console.log "brng" + brng

  # calcul distance
  R = 6371
  dLat = toRad(lat2 - lat1)
  dLon = toRad(lon2 - lon1)
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  d = (R * c) * 1000
  console.log 'this is distance in meter' + ' ' + d
  #Create point between the two points to define the center of circle inside
  console.log lat3 = lat1 + (lat2 - lat1)/2
  console.log lon3 = lon2 + (lon1 - lon2)/2
  aaa = "this is middle"

  # get data from Factual
  keyFactual = 'Y1irlCd3KfTm113yFd3GVlDzkGvtbzU5nqNteLqZ'
  filterInJson = '{"$circle":{"$center":[#{lat3},#{lon3}],"$meters":#{d}}}' + '?filters={category_ids:{"$includes":123}}'
  objectFilter = EJSON.stringify(filterInJson)
  newtest = EJSON.parse objectFilter
  console.log newtest
  urlFac = "http://api.v3.factual.com/t/restaurants-us?geo=" + newtest + "&KEY=#{keyFactual}"
  console.log urlFac
  # console.log A
  Factual = undefined
  factual = undefined
  Factual = Meteor.npmRequire("factual-api")
  factual = new Factual("Y1irlCd3KfTm113yFd3GVlDzkGvtbzU5nqNteLqZ", "nAYWpc1AZx6TwdsmwwpxT526Oq6YqSMjiE4ERKuV")

  factual.get "/t/places-us",
    filters:
      category_ids:
        $includes: 347
  , Meteor.bindEnvironment (error, res) ->
    console.log res.data
    # Markers.insert(markerObject(-118.419078, 34.058629))
    # markeru = Markers.findOne({lng: 34.058629})
    # console.log markeru
    # Markers.update
    #   _id: markeru._id
    # ,
    #   yelp: true,
    #   name: "test"
    #   lng: -118.419078
    #   lat: 34.058629
    lengthOfJson = res.data.length
    limit = lengthOfJson - 1
    for i in [0...limit]
      # console.log res.data
      console.log country = res.data[i].country
      console.log latFactual = res.data[i].latitude
      console.log lonFactual = res.data[i].longitude
      console.log name = res.data[i].name
      console.log tel = res.data[i].tel
      console.log factual_id = res.data[i].factual_id
      console.log region = res.data[i].region
      console.log postcode = res.data[i].postcode
      console.log fax = res.data[i].fax
      yelp = false
      url = undefined
      Markers.insert(markerObject(latFactual, lonFactual, name, tel, factual_id, region, postcode, fax, url, yelp))
      marker = Markers.findOne({lat: latFactual, lng: lonFactual, yelp: true})
      if marker is undefined
        console.log 'not this one'
      else
        console.log 'here is marker' + marker._id + latData + lngData + name + tel + factual_id + region + postcode + fax + url + yelp
        yelp = true
        Markers.update
          _id: marker._id
        ,
          lat: latData
          lng: lngData
          name: name
          tel: tel
          factual_id: factual_id
          region: region
          postcode: postcode
          fax: fax
          yelp: yelp

urlMaker = (SElng, SElat, NWlng, NWlat) ->
  console.log 'urlMaker'
  boundlnglat = SElng + "," + SElat + "," + NWlng + "," + NWlat
  urlTo =  "http://www.yelp.com/search?find_desc=&find_loc=shopping&l=g:" + boundlnglat
  return uuuRl = encodeURI urlTo

lonN = undefined
latN = undefined
lonNn = undefined
latNn = undefined
yelpCrawl = (lonN, latN, lonNn, latNn, uuuRl) ->
  console.log 'yelpCrawl'
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
  clean = (txt) ->
    chr = ['\\']
    i = 0
    while i <= 0
      cleanS = txt.split(chr[i]).join("")
      i++
  $ = Meteor.http.get uuuRl
  console.log $
  b = JSON.stringify($);
  # console.log b
  numberOfPages = b.indexOf("prev-next");
  data = b.substring(numberOfPages - 109, numberOfPages)
  # console.log data
  numbOf = data.charAt(0)
  # console.log numbOf
  n = b.indexOf("]}}}");
  m = b.indexOf("latitude")
  res = b.substring(m, n + 4);
  o = res.indexOf("zoom");
  console.log better = res.substring(o + 13);
  clean('{' + better + '}')
  scrap = EJSON.parse(cleanS)
  console.log scrap
  a = scrap.markers
  console.log a
  length = (Object.keys(a).length)

  console.log indexForThatStringInit = b.indexOf('Page 1 of') + 9
  console.log indexForThatStringEnd  = indexForThatStringInit + 5
  console.log thatString = b.substring(indexForThatStringInit, indexForThatStringEnd)
  console.log numberOfPagesAvailable = parseInt(thatString)
  for i in [1...length]
    latData = a[i].location.latitude
    lngData = a[i].location.longitude
    urli = a[i].url
    yelp = true
    Markers.insert(markerObject(latData, lngData, name, tel, factual_id, region, postcode, fax, urli, yelp))
    console.log urli + " " + latData + " " + lngData
    console.log('end')
    factualCrawl(lonN, latN, lonNn, latNn, latData, lngData)

crawler = () ->
  console.log 'crawler'
  array = Bounds.find().fetch()
  for key, object of array
    # console.log object.marker0[0] + "it goes here"
    # urLoop = urlMaker(object.marker0[0], object.marker0[1], object.marker1[1], object.marker1[0])
    # console.log urLoop
    yelpCrawl(object.NW[0], object.NW[1], object.SE[0], object.SE[1], object.url)

@latN0 = undefined
@lonN0 = undefined
@latN1 = undefined
@lonN1 = undefined
arrayOfObj = []
saveBound = (NWlng, NWlat, SElng, SElat, url, type) ->
  console.log 'saveBound'
  if type = "db"
    Bounds.insert {
      NW: [NWlng, NWlat]
      SE: [SElng, SElat]
      url: url
    }
  if type = "ar"
    arrayOfObj.push {
      NW: [NWlng, NWlat]
      SE: [SElng, SElat]
      url: url
    }

northToSouth = (latLim) ->
  console.log 'southToNord'
  for key, object of arrayOfObj
    if object.SE[1] > latLim
      console.log 'after for'
      NWlng = object.NW[0]
      NWlat = object.NW[1] - val
      SElng = object.SE[0]
      SElat = object.SE[1] - val
      urlE = urlMaker(SElng, SElat, NWlng, NWlat)
      saveBound(SElng, SElat, NWlng, NWlat, urlE, "db")
      saveBound(SElng, SElat, NWlng, NWlat, "ar")
      eastToWest(latLim)
      northToSouth(latLim)
    else
      crawler()

last = undefined
eastToWest = (lonLim, latLim) ->
  console.log 'eastToWest'
  last = arrayOfObj[-1..]
  console.log last
  for key, object of last
    if object.SE[0] < lonLim
      console.log 'after for'
      NWlng = object.NW[0] + val
      NWlat = object.NW[1]
      SElng = object.SE[0] + val
      SElat = object.SE[1]
      urlE = urlMaker(SElng, SElat, NWlng, NWlat)
      saveBound(SElng, SElat, NWlng, NWlat, urlE, "db")
      saveBound(SElng, SElat, NWlng, NWlat, urlE, "ar")
      eastToWest(lonLim, latLim)
    else
      northToSouth(latLim)

makeSearch = (lonLim, latLim) ->
  console.log 'makeSearch'
  return eastToWest(lonLim, latLim)
# array = undefined
initSearch = () ->
  console.log 'initSearch'
  array = Searchs.find().fetch()
  for key, object of array
    assocLng = object.NW[0] + val
    assocLat = object.SE[1] - val
    url1 = urlMaker(assocLng, assocLat, object.NW[0], object.NW[1])
    arrayOfObj.push {
      NW: [object.NW[0], object.NW[1]]
      SE: [assocLng, assocLat]
      url: url1
    }
    makeSearch(object.SE[0], object.SE[1])

count = 0
query = Searchs.find({})
handle = query.observeChanges(
  added: (id, user) ->
    count++
    console.log count
    initSearch()
    return

  removed: ->
    count--
    console.log "Lost one. We're now down to " + count + " admins."
    return
)

