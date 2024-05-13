# 容器技术在Linux桌面程序分发中的应用

black_desk 01/20/24

---

## 目录

- 容器技术
- 应用分发
 
---

## 容器技术

- docker
- podman
- k8s

---

## 容器技术>原理介绍>内核

- namespace
- cgroup

---

## 容器技术>原理介绍>namespace

|Namespace |Flag            |Page                  |Isolates                            |
|----------|----------------|----------------------|------------------------------------|
|Cgroup    |CLONE_NEWCGROUP |cgroup_namespaces(7)  |Cgroup root directory               |
|IPC       |CLONE_NEWIPC    |ipc_namespaces(7)     |System V IPC, POSIX message queues  |
|Network   |CLONE_NEWNET    |network_namespaces(7) |Network devices, stacks, ports, etc.|
|Mount     |CLONE_NEWNS     |mount_namespaces(7)   |Mount points                        |
|PID       |CLONE_NEWPID    |pid_namespaces(7)     |Process IDs                         |
|Time      |CLONE_NEWTIME   |time_namespaces(7)    |Boot and monotonic clocks           |
|User      |CLONE_NEWUSER   |user_namespaces(7)    |User and group IDs                  |
|UTS       |CLONE_NEWUTS    |uts_namespaces(7)     |Hostname and NIS domain name        |

---

## 容器技术>原理介绍>cgroup(v2)

- cpu
- cpuset
- freezer
- hugetlb
- io
- memory
- perf_event
- pids
- rdma

---

## 容器技术>原理介绍>使用

- fork
- clone
- unshare
- setns

---

## 容器技术>OCI

Open Container Initiative

- OCI runtime
- OCI image
- OCI distribution

---

## 容器技术>rootless

- mount
- capabilities
- limits

---

## 容器技术>rootless

- mount
  - sysfs
  - overlayfs
  - fuse
- capabilities
- limits

---

## 容器技术>rootless

- mount
- capabilities
- limits
  - unprivileged_userns_clone
  - /proc/sys/user/max_XXX_namespaces

WHY?

- CVE-2022-0492
- CVE-2023-0179
- CVE-2023-31248
- https://github.com/black-desk/fake-proc-pid-exe

---

## 应用分发>现状

- 分发困难
- 依赖关系
- 接口兼容性

---

## 应用分发>解决方案

- 只考虑开源软件
- 应用程序不/少使用系统依赖

---

## 应用分发>自带依赖

- 静态编译
- LD_LIBRARY_PATH/DT_RUNPATH
- Appimage
- container
- electron like

---

## 应用分发>container

- docker
- flatpak
- snap
- systemd
- linglong

---

## 应用分发>container

linglong: 一个更OCI一些的flatpak

- XDG
- OCI

- ll-package-manager
- ll-service
- ll-cli
- ll-box

---

## 应用分发>container

- 好处
  - 好管理
  - 隔离程度高

- 问题
  - 体积
  - DBus
  - 显示服务
  - PID
  - 资源文件访问
  - 读写文件

---

## Thanks
