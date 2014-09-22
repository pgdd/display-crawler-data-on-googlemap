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


$ = HTTP.get "http://www.yelp.com/search?find_desc=&find_loc=New+York+City%2C+NY%2C+USA&ns=1&ls=cf0b18d10d416e2c#cflt=shopping&l=g:-74.0052205324173,40.71461387762443,-74.00858938694,40.71258081801618"
# console.log $
b = JSON.stringify($);
n = b.indexOf("]}}}");
m = b.indexOf("latitude")
res = b.substring(m, n + 4);
o = res.indexOf("zoom");
better = res.substring(o + 13);
clean('{' + better + '}')
scrap = EJSON.parse(cleanS)
a = scrap.markers
console.log a
console.log typeof a
console.log length = (Object.keys(a).length)
# console.log latData = a[1].location.latitude
for i in [1...length]
  latData = a[i].location.latitude
  lngData = a[i].location.longitude
  description = a[i].url
  Markers.insert(markerObject(latData, lngData, description))
  console.log('end')


