uuuRl = undefined
lonN = - 73.99735629558563
latN = 40.71320735837452
lonNn = - 73.99904072284698
latNn = 40.712190814856044
urlMaker = (lonNn, latNn, lonN, latN) ->
  boundlnglat = lonNn + "," + latNn + "," + lonN + "," + latN
  urlTo =  "http://www.yelp.com/search?find_desc=&find_loc=shopping&l=g:" + boundlnglat
  return uuuRl = encodeURI urlTo
crawler = () ->
  array = Bounds.find().fetch()
  for key, object of array
    # console.log object.marker0[0] + "it goes here"
    # urLoop = urlMaker(object.marker0[0], object.marker0[1], object.marker1[1], object.marker1[0])
    # console.log urLoop
    crawl(object.marker0[1], object.marker0[0], object.marker1[1], object.marker1[0], object.url)
crawl = (lonN, latN, lonNn, latNn, urlTo) ->
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
  markerObject = (latData, lngData, name, tel, factual_id, region, postcode, fax, url, yelp) ->
    {lat: latData, lng: lngData, name: name, tel: tel, factual_id: factual_id, region: region, postcode: postcode, fax: fax, url: url, yelp: yelp}

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
    console.log url + " " + latData + " " + lngData
    console.log('end')


  # test define center of a c
  lat1 = 40.76679992935825
  lon1 = -73.96784278317864
  lat2 = 40.76883133248217
  lon2 = -73.96447392865593
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
  findMiddle = () ->
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
      Markers.insert(markerObject(-118.419078, 34.058629))
      markeru = Markers.findOne({lng: 34.058629})
      console.log markeru
      Markers.update
        _id: markeru._id
      ,
        yelp: true,
        name: "test"
        lng: -118.419078
        lat: 34.058629
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

  findMiddle()

@latN0 = undefined
@lonN0 = undefined
@latN1 = undefined
@lonN1 = undefined
lat0 = latN
lon0 = lonN
lat1 = latNn
lon1 = lonNn
# val = 0 - (lon1 - lon0)
valY = undefined
@arrayOfObj = []
last = undefined
urlE = undefined
# val = undefined
isOdd = (num) ->
 console.log num % 2

squareNw = () ->
  console.log 'squareNw'
  eastToWest = () ->
    console.log 'eastToWest'
    last = arrayOfObj[-1..]
    console.log last
    for key, object of last
      val = 0.01
      console.log 'after for'
      console.log 'x0' + X0 = object.marker0[0] + val
      console.log 'y0' + Y0 = object.marker0[1]
      X1 = object.marker1[0] + val
      Y1 = object.marker1[1]
      urlE = urlMaker(X1, Y1, X0, Y0)
      saveBound(Y0, X0, Y1, X1, urlE, "db")
      saveBound(X0, Y0, X1, Y1, urlE, "ar")
      eastToWest()

  eastToWest()

saveBound = (lonN0, latN0, lonN1, latN1, url, type) ->
  console.log 'saveBound'
  if type = "db"
    marker0 = [lonN0, latN0]
    marker1 = [lonN1, latN0]
    Bounds.insert {
      marker0: marker0
      marker1: marker1
      url: url
    }
  if type = "ar"
    console.log latN0
    console.log lonN0
    marker0 = [lonN0, latN0]
    marker1 = [lonN1, latN1]
    arrayOfObj.push {
      marker0: marker0
      marker1: marker1
      url: url
    }


eastToWest = (latMax, lonMax) ->
  console.log 'eastToWest'
  last = arrayOfObj[-1..]
  console.log last
  for key, object of last
    if object.marker0[1] < lonMax
      val = 0.01
      console.log 'after for'
      console.log 'x0' + X0 = object.marker0[0] + val
      console.log 'y0' + Y0 = object.marker0[1]
      X1 = object.marker1[0] + val
      Y1 = object.marker1[1]
      urlE = urlMaker(X1, Y1, X0, Y0)
      saveBound(Y0, X0, Y1, X1, urlE, "db")
      saveBound(Y0, X0, Y1, X1, urlE, "ar")
      eastToWest()
    else
      southToNord(latMax)

southToNord = (latMax) ->
    for key, object of arrayOfObj
      if object.marker0[0] < latMax
        val = 0.01
        console.log 'after for'
        console.log 'x0' + X0 = object.marker0[0]
        console.log 'y0' + Y0 = object.marker0[1] + val
        X1 = object.marker1[0]
        Y1 = object.marker1[1] + val
        urlE = urlMaker(X1, Y1, X0, Y0)
        saveBound(Y0, X0, Y1, X1, urlE, "db")
        saveBound(Y0, X0, Y1, X1, urlE, "ar")
        southToNord()
      else
        crawler()

makeSearch = (latMax, lonMax) ->
  return eastToWest(latMax,lonMax)

initSearch = () ->
    array = Searchs.find().fetch()
    for key, object of array
      val = 0.01
      assocLat = object.SW[1] + val
      assocLng = object.SW[0]+ val
      url1 = urlMaker(assocLng, assocLat, object.SW[0], object.SW[1])
      arrayOfObj.push {
        marker0: [object.SW[0], object.SW[1]]
        marker1: [assocLng, assocLat]
        URL: url1
      }
      makeSearch(object.NE[1], object.NE[0])



saveBound = (lonN0, latN0, lonN1, latN1, url, type) ->
  console.log 'saveBound'
  if type = "db"
    marker0 = [lonN0, latN0]
    marker1 = [lonN1, latN0]
    Bounds.insert {
      marker0: marker0
      marker1: marker1
      url: url
    }
  if type = "ar"
    console.log latN0
    console.log lonN0
    marker0 = [lonN0, latN0]
    marker1 = [lonN1, latN1]
    arrayOfObj.push {
      marker0: marker0
      marker1: marker1
      url: url
    }


# functionTestUrl = (url) ->
#   clean = (txt) ->
#     chr = ['\\']
#     i = 0
#     while i <= 0
#       return cleanS = txt.split(chr[i]).join("")
#       i++
#   cleanS = undefined
#   scrap = [{}]
#   markers = [{}]
#   location = [{}]
#   url = [{}]
#   country = undefined
#   latFactual = undefined
#   lonFactual = undefined
#   name = undefined
#   tel = undefined
#   factual_id = undefined
#   region = undefined
#   postcode = undefined
#   fax = undefined
#   array = Bounds.find().fetch()
#   for key, object of array
#     $ = Meteor.http.get object.url
#     console.log $
#     b = JSON.stringify($);
#     # console.log b
#     numberOfPages = b.indexOf("prev-next");
#     data = b.substring(numberOfPages - 109, numberOfPages)
#     # console.log data
#     numbOf = data.charAt(0)
#     # console.log numbOf
#     n = b.indexOf("]}}}");
#     m = b.indexOf("latitude")
#     res = b.substring(m, n + 4);
#     o = res.indexOf("zoom");
#     console.log better = res.substring(o + 13);
#     clean('{' + better + '}')
#     scrap = EJSON.parse(cleanS)
#     console.log scrap
#     a = scrap.markers
#     console.log a
#     length = (Object.keys(a).length)
#     console.log indexForThatStringInit = b.indexOf('Page 1 of') + 9
#     console.log indexForThatStringEnd  = indexForThatStringInit + 5
#     console.log thatString = b.substring(indexForThatStringInit, indexForThatStringEnd)
#     console.log numberOfPagesAvailable = parseInt(thatString)
#     for i in [1...length]
#       latData = a[i].location.latitude
#       lngData = a[i].location.longitude
#       urli = a[i].url
#       yelp = true
#       Markers.insert(markerObject(latData, lngData, name, tel, factual_id, region, postcode, fax, urli, yelp))
#       console.log url + " " + latData + " " + lngData
#       console.log('end')
# squareNw()
# crawler()
# functionTestUrl()

# Keep track of how many administrators are online.
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

# After five seconds, stop keeping the count.
setInterval (->
  handle.start
  return
), 3000
