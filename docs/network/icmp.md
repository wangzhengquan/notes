# ICMP（Internet control message protocol）
ICMP是在网络层之上的协议，所以应该算是传输层协议，虽然ICMP是在网络层用来报告错误和诊断问题的。

## 报告错误（reporting errors）

ICMP 的主要目的是报告错误。例如端点A发送一个http请求给端点B，在请求包经过A和B之间的某个路由器的时候，发现路由表里找不到对应到B的地址， 就会产生一个ICMP错误消息包。这个错误消息的类型是 “destination network unreachable” 所以它的type是3，code是0。它们会被放到ICMP的消息头里面，另外ICMP还包含了发生错误的原包的ip header, 以及ip data的前8个字节。这个错误消息包会被包在一个新的IP包里，新IP包的source是该路由器的地址，destnation是端点A的地址，该包被路由器发送回端点A，端点A由此知道消息发送失败。

ICMP消息的格式如下：
```
0                   1                   2                   3
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     Type      |     Code      |          Checksum             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                             unused                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|      Internet Header + 64 bits of Original Data Datagram      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

ICMP 常用的消息类型如下：

| ICMP type | ICMP code | Description   |
|:----------|:----------| :-------------|
| 0  | 0 | echo reply (to ping)                 |
| 3  | 0 | destination network unreachable      |
| 3  | 1 | destination host unreachable         |
| 3  | 2 | destination protocol unreachable     |
| 3  | 3 | destination port unreachable         |
| 3  | 6 | destination network unknown          |
| 3  | 7 | destination host unknown             |
| 4  | 0 | source quench (congestion control)   |
| 8  | 0 | echo request                         |
| 9  | 0 | router advertisement                 |
| 10 | 0 | router discovery                     |
| 11 | 0 | TTL expired                          |
| 12 | 0 | IP header bad                        |


## 网络诊断（diagnostic）
ICMP 协议的第二个用途是执行网络诊断。常用的终端实用程序 traceroute 和 ping 都使用 ICMP 协议。

### ping 
网络ping工具使用了ICMP协议，发起ping 的一端的ICMP消息类型是“echo request”，因此该ICMP包的type=8, code=0，该ICMP包会被包在ip包中发送给被ping的一端。被ping的一端返回的ICMP消息类型是“echo reply ”，因此该ICMP包的type=0, code=0，该ICMP包也会被包在ip包中回馈给发送端。

### traceroute
traceroute 是一个用来探测消息包所通过的网络路径即该路径上所经过的路由的应用。例如，你可以通过输入“traceroute baidu.com” 来尝试这个应用。traceroute不但会告诉你包所经过的路由，还会告诉你所到达的每个路由所需要的round-trip time。traceroute的目的就是要找的从源端到目的端所经过的路由，并确认到达每个路由所需要的round-trip time。traceroute通过向目的端发送一个UDP包，该包可以是任何内容，把这个包包裹在一个IP包中，IP包header中的TTL是1，当这个IP包到达第一个路由时TTL减1变为0,这就会产生一个“TTL expired”事件，导致这个包会被丢弃，并产生一个ICMP错误消息包，该消息包的类型是"TTL expired"，因此ICMP包header的type=1,code=0。该包被包裹在IP包中发送回源端。源端通过解析IP header的source得到路由地址，并通过计算开始与结束时间的差值得到round-trip time。完成第一个路由的探测后traceroute会接着发送下一个包，新包的TTL是2, 那么这个包会在到达第二个路由的时候TTL减为0,产生“TTL expired”事件，这样就获得了第二个路由的地址和到达该路由所需要的round-trip time。重复上述过程，每次发送新包的TTL比上次大1,直到最后一个包到达目的端，因为UDP包的端口号是一个故意设置的不可能存在的端口，所以会产生一个“destination port unreachable ”的ICMP消息包, 该包的header的type=3, code=3。当该包被发送回源端，traceroute通过该ICMP包的类型判断出已经到达了目的端，完成探测。


 
