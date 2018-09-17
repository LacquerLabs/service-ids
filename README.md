# Service IDS


## TL;DR - NT;WTF?

```
# make build
# make start
```

`make` on it's own will show options


## Exposed Services

* [kibana](http://localhost:5601/)
* [evebox](http://localhost:5636/)
* [grafana](http://localhost:3000/)

on host:

```
ip link set <INTERFACE> multicast off
ip link set <INTERFACE> promisc on
ip link set <INTERFACE> up
```

test
```
# curl -k -d "pin=1234&ccv=123&creditcard=4444-4444-4444-4444&expyear=1922" -X POST https://127.0.0.1/
# curl -k -d "pin=1234&ccv=123&creditcard=4444-4444-4444-4444&expyear=1922" -X POST http://whamcat.com/ip/
```

```
suricata-update --reload-command='suricatasc -c reload-rules'
```

template
```
PUT _template/logstash
{
  "index_patterns": "logstash-*",
  "version": 1,
  "mappings": {
    "doc": {
      "dynamic": "true",
      "properties": {
        "geoip": {
          "dynamic": true,
          "properties": {
            "location": {
              "type": "geo_point"
            }
          }
        },
        "geoip_dst": {
          "dynamic": true,
          "properties": {
            "location": {
              "type": "geo_point"
            }
          }
        }
      }
    }
  }
}
```

```
# wait until ES is up
until $(curl -o /dev/null -s --head --fail $baseUrl); do
    echo "Waiting for ES to start..."
    sleep 5
done
```

curl -X PUT "localhost:9200/_template/template_1" -H 'Content-Type: application/json' -d'
{
    "index_patterns" : ["te*"],
    "settings" : {
        "number_of_shards" : 1
    },
    "aliases" : {
        "alias1" : {},
        "alias2" : {
            "filter" : {
                "term" : {"user" : "kimchy" }
            },
            "routing" : "kimchy"
        },
        "{index}-alias" : {}
    }
}
'
