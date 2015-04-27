container = ig.containers.base

mapElement = document.createElement \div
  ..setAttribute \class \map
container.appendChild mapElement
map = L.map do
  * mapElement
  * minZoom: 6,
    maxZoom: 14,
    zoom: 8,
    center: [49.78, 15.5]
    maxBounds: [[48.3,11.6], [51.3,19.1]]

baseLayer = L.tileLayer do
  * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
  * zIndex: 1
    opacity: 1
    attribution: 'data <a href="http://www.zzshmp.cz/" target="_blank">ZZS HMP</a>, mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

labelLayer = L.tileLayer do
  * "https://samizdat.cz/tiles/ton_l2/{z}/{x}/{y}.png"
  * zIndex: 2

ig.map = map
  ..addLayer baseLayer
  ..addLayer labelLayer

cities = ig.prepareData!
for city in cities
  city.value = city.players.length

valueExtent = d3.extent cities.map (.value)
radiusScale = d3.scale.sqrt!
  ..domain valueExtent
  ..range [35 60]

colorScale = d3.scale.linear!
  ..domain ig.utils.divideToParts valueExtent, 5
  ..range ['rgb(116,169,207)','rgb(54,144,192)','rgb(5,112,176)','rgb(4,90,141)','rgb(2,56,88)']

for city in cities
  count = city.value
  color = colorScale count
  radius = Math.floor radiusScale count
  latLng = city.latLng
  zIndexOffset = (30 - count) * 50
  icon = L.divIcon do
    html: "<div style='background-color: #color;line-height:#{radius}px'><span>#{ig.utils.formatNumber count}</span></div>"
    iconSize: [radius, radius]
  marker = L.marker latLng, {icon, zIndexOffset}
    ..addTo map