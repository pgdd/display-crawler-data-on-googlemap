# cheerio = Meteor.npmRequire 'cheerio'
# Meteor.publish "markers", ->
#   Markers.find({})

cleanS = undefined
scrap = [{}]
markers = [{}]
location = [{}]
url = [{}]
markerObject = (latData, lngData, description, imageId, formatedAddress) ->
  {lat: latData, lng: lngData, description: description, imageId: imageId, address: formatedAddress}

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
$ = HTTP.get "http://www.yelp.com/search?find_desc=&find_loc=shopping&l=g:-73.96447392865593,40.76883133248217,-73.96784278317864,40.76679992935825"
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
  description = a[i].url
  Markers.insert(markerObject(latData, lngData, description))
  console.log description + " " + latData + " " + lngData
  console.log('end')


