# Service IDS

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

