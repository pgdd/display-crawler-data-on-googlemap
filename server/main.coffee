# cheerio = Meteor.npmRequire 'cheerio'
cleanS = undefined
scrap = [{}]
markers = [{}]
location = [{}]
url = [{}]
clean = (txt) ->
  chr = ['\\']
  i = 0
  while i <= 0
    cleanS = txt.split(chr[i]).join("")
    i++
  console.log cleanS


$ = HTTP.get "http://www.yelp.com/search?find_desc=&find_loc=New+York+City%2C+NY%2C+USA&ns=1&ls=cf0b18d10d416e2c#cflt=shopping&l=g:-74.0052205324173,40.71461387762443,-74.00858938694,40.71258081801618"
console.log $
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
console.log a[1].url
console.log a[1].location.latitude
console.log a[1].location.longitude
  # ...
# `var serious = [
#       scrap
#   ]`

# console.log serious

