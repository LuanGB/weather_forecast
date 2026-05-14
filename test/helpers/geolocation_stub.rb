GEOLOCATION_URL_DEFAULTS = {
  "accept-language" => "en",
  "addressdetails" => "1",
  "format" => "json",
  "q" => "Avenida Bernardo Vieira,,Natal,Rio Grande do Norte,Brazil"
}.freeze

GEOLOCATION_URL_FAILURE_DEFAULTS = {
  "accept-language" => "en",
  "addressdetails" => "1",
  "format" => "json",
  "q" => ",,Invalid City,Invalid State,Invalid Country"
}.freeze

GEOLOCATION_BODY_DEFAULTS = {
  "place_id": 14858053, "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
  "osm_type": "way", "osm_id": 1036416962, "lat": "-5.8015083", "lon": "-35.2363778", "class": "highway",
  "type": "trunk", "place_rank": 26, "importance": 0.05339834515907527, "addresstype": "road", "name": "Avenida Nevaldo Rocha",
  "display_name": "Avenida Nevaldo Rocha, Vila Novo Horizonte/Favela do Japão, Quintas, Zona Oeste, Natal, Rio Grande do Norte, Northeast Region, 59035-070, Brazil",
  "address": { "road": "Avenida Nevaldo Rocha", "neighbourhood": "Vila Novo Horizonte/Favela do Japão", "suburb": "Quintas",
  "city_district": "Zona Oeste", "city": "Natal", "state": "Rio Grande do Norte", "ISO3166-2-lvl4": "BR-RN", "region": "Northeast Region",
  "postcode": "59035-070", "country": "Brazil", "country_code": "br" }, "boundingbox": [ "-5.8017228", "-5.8011534", "-35.2370008", "-35.2356927" ]
}.freeze

def geolocation_stub(url_options: {}, override_body: {})
  url = URI::HTTPS.build(host: "nominatim.openstreetmap.org", path: "/search", query: GEOLOCATION_URL_DEFAULTS.merge(url_options).to_query).to_s
  body = GEOLOCATION_BODY_DEFAULTS.merge(override_body)
  stub_request(:get, url).
    with(
      headers: { "Accept"=>"*/*", "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "User-Agent"=>"Avenue Code Weather App/1.0 (luan.goncbs@gmail.com)" }).
    to_return(status: 200, body: body.to_json, headers: {})
end

def geolocation_stub_failure(url_options: {}, override_body: {})
  url = URI::HTTPS.build(host: "nominatim.openstreetmap.org", path: "/search", query: GEOLOCATION_URL_FAILURE_DEFAULTS.merge(url_options).to_query).to_s
  stub_request(:get, url).
    with(
      headers: { "Accept"=>"*/*", "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3", "User-Agent"=>"Avenue Code Weather App/1.0 (luan.goncbs@gmail.com)" }).
    to_return(status: 200, body: [].to_json, headers: {})
end
