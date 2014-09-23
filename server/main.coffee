# cheerio = Meteor.npmRequire 'cheerio'
# Meteor.publish "markers", ->
#   Markers.find({})

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
  # console.log cleanS
  # "http://www.yelp.com/search?find_desc=shopping&ns=1#find_loc=10159&
# url1 = "http://www.yelp.com/search?find_desc=shopping&ns=1#find_loc=Paris"
# url1 = "http://www.yelp.com/search?find_desc=shopping&ns=1#find_loc=New+York,+NY+10159&l=g:-73.99020552635193,40.74052953220297,-73.99188995361328,40.73951340594177"
# ur = http://www.yelp.com/search?find_desc=shopping&ns=1#find_loc=New+York,+NY+10159&l=g:-73.99020552635193,40.74052953220297,-73.99188995361328,40.73951340594177
$ = Meteor.http.get "http://www.yelp.com/search?find_desc=&find_loc=shopping&l=g:-73.96447392865593,40.76883133248217,-73.96784278317864,40.76679992935825"
# $ = HTTP.get "http://www.yelp.com/search?find_desc=&find_loc=New+York+City%2C+NY%2C+USA&ns=22&ls=cf0b18d10d416e2c#cflt=shopping&l=g:-74.0052205324173,40.71461387762443,-74.00858938694,40.71258081801618"
# $ = HTTP.get "http://www.yelp.com/search?find_desc=&find_loc=New+York+City%2C+NY%2C+USA&ns=1&ls=cf0b18d10d416e2c#cflt=shopping&l=g:-74.0052205324173,40.71461387762443,-74.00858938694,40.71258081801618"
# $ = HTTP.get "http://www.yelp.com/search?find_desc=&find_loc=New+York+City%2C+NY%2C+USA&ns=1#cflt=shopping&l=g:-73.98993194103241,40.72597751524788,-73.99161636829376,40.72496116672323"
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
# console.log a
# console.log typeof a
length = (Object.keys(a).length)
# console.log latData = a[1].location.latitude
# Get the real number of Pages avaialbe
console.log indexForThatStringInit = b.indexOf('Page 1 of') + 9
console.log indexForThatStringEnd  = indexForThatStringInit + 5
console.log thatString = b.substring(indexForThatStringInit, indexForThatStringEnd)
console.log numberOfPagesAvailable = parseInt(thatString)
# console.log real = b.charAt(indexForThat + 1)
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
  # bbb = "secondttt"
  # fff = "firstt"
  # Markers.insert(markerObject(lat1, lon1, fff))
  # Markers.insert(markerObject(lat2, lon2, bbb))
  # yelp = false
  # Markers.insert(markerObject(lat3, lon3, name, tel, factual_id, region, postcode, fax, aaa, yelp))

  # get data from Factual
  keyFactual = 'Y1irlCd3KfTm113yFd3GVlDzkGvtbzU5nqNteLqZ'
  filterInJson = '{"$circle":{"$center":[#{lat3},#{lon3}],"$meters":#{d}}}'
  objectFilter = EJSON.stringify(filterInJson)
  newtest = EJSON.parse objectFilter
  console.log newtest
  urlFac = "http://api.v3.factual.com/t/restaurants-us?geo=" + newtest + "&KEY=#{keyFactual}"
  console.log urlFac
  # A = Meteor.http.get(urlFac)
  # console.log A
  Factual = undefined
  factual = undefined
  Factual = Meteor.npmRequire("factual-api")
  factual = new Factual("Y1irlCd3KfTm113yFd3GVlDzkGvtbzU5nqNteLqZ", "nAYWpc1AZx6TwdsmwwpxT526Oq6YqSMjiE4ERKuV")

  factual.get "/t/places-us",
  q: "coffee"
  geo:
    $circle:
      $center: [
        lat3
        lon3
      ]
      $meters: d
  , Meteor.bindEnvironment (error, res) ->
    lengthOfJson = res.data.length
    limit = lengthOfJson - 1
    for i in [0...limit]
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
      # marker = Markers.findOne({lat: latFactual})
      # console.log 'here is marker' + marker._id
      # array = Markers.find().fetch()
      # for key, object of array
      #   console.log key



# linkData = () ->
#   marker = Markers.findOne({_id: markerId})
#   array = Markers.find().fetch()
#       for key, object of array




findMiddle()


