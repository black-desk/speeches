# cgtproxy 一种新的透明代理配置方式

black_desk 08/24/23

---

## 现状

- 内网
- 网络调试

---

## 现状

用户设置 protocol://auth@server:port

```
app ---request--> target

V

app ---request--> proxy server

proxy server ---forward--> target
```

---

## 现状

- env
- gsettings

---

## 现状

- ~~劫持~~
- 建议

---

## 现状

问题：

- 协议不支持

---

## 现状

用户设置 protocol://auth@server:port

```
app ---request--> target

V

app ---request--> local proxy server

local proxy server ---forward--> remote proxy server

remote proxy server ---forward--> target
```
---

## 现状

问题：

- 协议不支持
- app不接受建议

---

## 需求

- 透明

---

## 需求

- 透明
- 分应用

---

## 其他系统

- Android
- Proxifier
- Surge

---

## cgproxy

<https://github.com/springzfx/cgproxy>

---

## cgproxy

- iptables
- cgroup
- tproxy

---

## cgproxy

问题：

- BPF
- cgroup移动
- 安全

---

## cgtproxy

<https://github.com/black-desk/cgtproxy>

---

## cgtproxy

- nft
- 动态规则

---

## cgtproxy

<https://asciinema.org/a/70AauwWbtiaWWHY3WAoJX1IIS>

---

## cgtproxy

```
new underlying event (file system event from inoitfy for now)
|
| received by
v
cgroup monitor
|
| produce
v
cgroup event
|
| send to
v
rulemanager
|
| write rules to
v
nftable
```

---

## 产出

- <https://github.com/black-desk/cgtproxy>
- <https://github.com/black-desk/zap-journal>
- <https://github.com/black-desk/journalfmt>
- <https://github.com/google/nftables/pulls?q=is%3Apr+author%3Ablack-desk+is%3Aclosed>
- <https://bugzilla.netfilter.org/show_bug.cgi?id=1686>

---

## 展望

- 集成local proxy server
- GUI
- 集成到deepin
- BUG：
  - docker
  - 时序问题
- 性能问题？
- 二进制体积
- netlink连接复用
