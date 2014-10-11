(function(){__coffeescriptShare = typeof __coffeescriptShare === 'object' ? __coffeescriptShare : {}; var share = __coffeescriptShare;
var NWlat, NWlng, arrayOfObj, crawler, eastToWest, factualCrawl, initSearch, isOdd, last, lat0, latN, latNn, lon0, lonN, lonNn, makeSearch, markerObject, northToSouth, observeSearchs, saveBound, urlE, urlMaker, uuuRl, valY, yelpCrawl;

uuuRl = void 0;

valY = void 0;

this.arrayOfObj = [];

urlE = void 0;

this.val = 0.003;

isOdd = function(num) {
  return console.log(num % 2);
};

markerObject = function(latData, lngData, name, tel, factual_id, region, postcode, fax, url, yelp) {
  return {
    lat: latData,
    lng: lngData,
    name: name,
    tel: tel,
    factual_id: factual_id,
    region: region,
    postcode: postcode,
    fax: fax,
    url: url,
    yelp: yelp
  };
};

lat0 = void 0;

lon0 = void 0;

NWlat = void 0;

NWlng = void 0;

factualCrawl = function(NWlng, NWlat, SElng, SElat) {
  var Bx, By, Factual, R, a, aaa, bearing, brng, c, d, dLat, dLon, factual, lat3, lon3, marker, markeru, toRad;
  console.log('factualCrawl');
  lat3 = void 0;
  lon3 = void 0;
  dLon = void 0;
  dLat = void 0;
  dLon = void 0;
  R = void 0;
  a = void 0;
  c = void 0;
  d = void 0;
  brng = void 0;
  Bx = void 0;
  By = void 0;
  marker = void 0;
  markeru = void 0;
  toRad = function(Value) {
    return Value * Math.PI / 180;
  };
  bearing = function() {
    var x, y;
    y = Math.sin(dLon) * Math.cos(SElat);
    x = Math.cos(NWlat) * Math.sin(SElat) - Math.sin(NWlat) * Math.cos(SElat) * Math.cos(dLon);
    brng = toRad(Math.atan2(y, x));
    return console.log("brng" + brng);
  };
  R = 6371;
  dLat = toRad(val);
  dLon = toRad(val);
  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(toRad(NWlat)) * Math.cos(toRad(SElat)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  d = (R * c) * 1000;
  console.log('this is distance in meter' + ' ' + d);
  console.log(lat3 = NWlat - 0.01);
  console.log(lon3 = NWlng + 0.01);
  aaa = "this is middle";
  Factual = void 0;
  factual = void 0;
  Factual = Meteor.npmRequire("factual-api");
  factual = new Factual("Y1irlCd3KfTm113yFd3GVlDzkGvtbzU5nqNteLqZ", "nAYWpc1AZx6TwdsmwwpxT526Oq6YqSMjiE4ERKuV");
  return factual.get("/t/places-us", {
    geo: {
      $circle: {
        $center: [lat3, lon3],
        $meters: d
      }
    }
  }, Meteor.bindEnvironment(function(error, res) {
    var country, factual_id, fax, i, latFactual, lengthOfJson, limit, lonFactual, name, postcode, region, tel, url, yelp, _i, _results;
    console.log(res.data);
    lengthOfJson = res.data.length;
    limit = lengthOfJson - 1;
    _results = [];
    for (i = _i = 0; 0 <= limit ? _i < limit : _i > limit; i = 0 <= limit ? ++_i : --_i) {
      console.log(country = res.data[i].country);
      console.log(latFactual = res.data[i].latitude);
      console.log(lonFactual = res.data[i].longitude);
      console.log(name = res.data[i].name);
      console.log(tel = res.data[i].tel);
      console.log(factual_id = res.data[i].factual_id);
      console.log(region = res.data[i].region);
      console.log(postcode = res.data[i].postcode);
      console.log(fax = res.data[i].fax);
      yelp = false;
      url = void 0;
      Markers.insert(markerObject(latFactual, lonFactual, name, tel, factual_id, region, postcode, fax, url, yelp));
      marker = Markers.findOne({
        lat: latFactual,
        lng: lonFactual,
        yelp: true
      });
      if (marker === void 0) {
        _results.push(console.log('not this one'));
      } else {
        console.log('here is marker' + marker._id + name + tel + factual_id + region + postcode + fax + url + yelp);
        yelp = true;
        _results.push(Markers.update({
          _id: marker._id
        }, {
          lat: latFactual,
          lng: lonFactual,
          name: name,
          tel: tel,
          factual_id: factual_id,
          region: region,
          postcode: postcode,
          fax: fax,
          yelp: yelp
        }));
      }
    }
    return _results;
  }));
};

urlMaker = function(SElng, SElat, NWlng, NWlat) {
  var boundlnglat, urlTo;
  console.log('urlMaker');
  boundlnglat = SElng + "," + SElat + "," + NWlng + "," + NWlat;
  urlTo = "http://www.yelp.com/search?find_desc=&find_loc=shopping&l=g:" + boundlnglat;
  return uuuRl = encodeURI(urlTo);
};

lonN = void 0;

latN = void 0;

lonNn = void 0;

latNn = void 0;

yelpCrawl = function(NWlng, NWlat, SElng, SElat, uuuRl) {
  var $, a, b, better, clean, cleanS, country, data, factual_id, fax, i, indexForThatStringEnd, indexForThatStringInit, latData, latFactual, length, lngData, location, lonFactual, m, markers, n, name, numbOf, numberOfPages, numberOfPagesAvailable, o, postcode, region, res, scrap, tel, thatString, url, urli, yelp, _i, _results;
  console.log('yelpCrawl');
  cleanS = void 0;
  scrap = [{}];
  markers = [{}];
  location = [{}];
  url = [{}];
  country = void 0;
  latFactual = void 0;
  lonFactual = void 0;
  name = void 0;
  tel = void 0;
  factual_id = void 0;
  region = void 0;
  postcode = void 0;
  fax = void 0;
  clean = function(txt) {
    var chr, i, _results;
    chr = ['\\'];
    i = 0;
    _results = [];
    while (i <= 0) {
      cleanS = txt.split(chr[i]).join("");
      _results.push(i++);
    }
    return _results;
  };
  $ = Meteor.http.get(uuuRl);
  console.log($);
  b = JSON.stringify($);
  numberOfPages = b.indexOf("prev-next");
  data = b.substring(numberOfPages - 109, numberOfPages);
  numbOf = data.charAt(0);
  n = b.indexOf("]}}}");
  m = b.indexOf("latitude");
  res = b.substring(m, n + 4);
  o = res.indexOf("zoom");
  console.log(better = res.substring(o + 13));
  clean('{' + better + '}');
  scrap = EJSON.parse(cleanS);
  console.log(scrap);
  a = scrap.markers;
  console.log(a);
  length = (Object.keys(a).length);
  console.log(indexForThatStringInit = b.indexOf('Page 1 of') + 9);
  console.log(indexForThatStringEnd = indexForThatStringInit + 5);
  console.log(thatString = b.substring(indexForThatStringInit, indexForThatStringEnd));
  console.log(numberOfPagesAvailable = parseInt(thatString));
  _results = [];
  for (i = _i = 1; 1 <= length ? _i < length : _i > length; i = 1 <= length ? ++_i : --_i) {
    latData = a[i].location.latitude;
    lngData = a[i].location.longitude;
    urli = a[i].url;
    yelp = true;
    Markers.insert(markerObject(latData, lngData, name, tel, factual_id, region, postcode, fax, urli, yelp));
    console.log(urli + " " + latData + " " + lngData);
    console.log('end');
    _results.push(factualCrawl(NWlng, NWlat, SElng, SElat));
  }
  return _results;
};

crawler = function() {
  var array, key, object, _results;
  console.log('crawler');
  array = Bounds.find().fetch();
  _results = [];
  for (key in array) {
    object = array[key];
    _results.push(yelpCrawl(object.NW[0], object.NW[1], object.SE[0], object.SE[1], object.url));
  }
  return _results;
};

this.latN0 = void 0;

this.lonN0 = void 0;

this.latN1 = void 0;

this.lonN1 = void 0;

arrayOfObj = [];

saveBound = function(NWlng, NWlat, SElng, SElat, url, type) {
  console.log('saveBound');
  if (type = "db") {
    Bounds.insert({
      NW: [NWlng, NWlat],
      SE: [SElng, SElat],
      url: url
    });
  }
  if (type = "ar") {
    return arrayOfObj.push({
      NW: [NWlng, NWlat],
      SE: [SElng, SElat],
      url: url
    });
  }
};

northToSouth = function(latLim) {
  var SElat, SElng, key, object, _results;
  console.log('southToNord');
  _results = [];
  for (key in arrayOfObj) {
    object = arrayOfObj[key];
    if (object.SE[1] > latLim) {
      console.log('after for');
      NWlng = object.NW[0];
      NWlat = object.NW[1] - val;
      SElng = object.SE[0];
      SElat = object.SE[1] - val;
      urlE = urlMaker(SElng, SElat, NWlng, NWlat);
      saveBound(SElng, SElat, NWlng, NWlat, urlE, "db");
      saveBound(SElng, SElat, NWlng, NWlat, "ar");
      eastToWest(latLim);
      _results.push(northToSouth(latLim));
    } else {
      _results.push(crawler());
    }
  }
  return _results;
};

last = void 0;

eastToWest = function(lonLim, latLim) {
  var SElat, SElng, key, object, _results;
  console.log('eastToWest');
  last = arrayOfObj.slice(-1);
  console.log(last);
  _results = [];
  for (key in last) {
    object = last[key];
    if (object.SE[0] < lonLim) {
      console.log('after for');
      NWlng = object.NW[0] + val;
      NWlat = object.NW[1];
      SElng = object.SE[0] + val;
      SElat = object.SE[1];
      urlE = urlMaker(SElng, SElat, NWlng, NWlat);
      saveBound(SElng, SElat, NWlng, NWlat, urlE, "db");
      saveBound(SElng, SElat, NWlng, NWlat, urlE, "ar");
      _results.push(eastToWest(lonLim, latLim));
    } else {
      _results.push(northToSouth(latLim));
    }
  }
  return _results;
};

makeSearch = function(lonLim, latLim) {
  console.log('makeSearch');
  return eastToWest(lonLim, latLim);
};

initSearch = function() {
  var array, assocLat, assocLng, key, object, url1, _results;
  console.log('initSearch');
  array = Searchs.find().fetch();
  _results = [];
  for (key in array) {
    object = array[key];
    assocLng = object.NW[0] + val;
    assocLat = object.SE[1] - val;
    url1 = urlMaker(assocLng, assocLat, object.NW[0], object.NW[1]);
    arrayOfObj.push({
      NW: [object.NW[0], object.NW[1]],
      SE: [assocLng, assocLat],
      url: url1
    });
    _results.push(makeSearch(object.SE[0], object.SE[1]));
  }
  return _results;
};

observeSearchs = function() {
  var count, handle, query;
  count = 0;
  query = Searchs.find({});
  return handle = query.observeChanges({
    added: function(id, user) {
      count++;
      console.log(count);
      initSearch();
    },
    removed: function() {
      count--;
      console.log("Lost one. We're now down to " + count + " admins.");
    }
  });
};

observeSearchs();

})();
