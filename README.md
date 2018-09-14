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
# curl -k -d "pin=1234&ccv=123&creditcard=4444-4444-4444-4444&expyear=1922" -X POST http://127.0.0.1/
```

