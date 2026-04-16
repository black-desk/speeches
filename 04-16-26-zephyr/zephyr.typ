// #import "@preview/touying:0.7.1": *
// #import themes.stargazer: *

// #show: stargazer-theme.with(
  // config-info(
    // author: [陈麟轩],
    // date: datetime.today(),
    // contact: [chenlx163\@chinaunicom.cn],
  // ),
// )

#set par(first-line-indent: (all: true, amount: 2em))

#set text(
  lang: "zh",
  font: "Noto Serif CJK SC",
)

= Zephyr调研

== 内核架构

- 宏内核

  最终部署的产物是单个二进制，内核代码（包括驱动）和应用层代码是链接在一起的。
  没有syscall，全是函数调用。

- v1.6.0版本之前的zephyr也是宏内核；

  `microkernel`是项目内的一种构建模式，和学术意义上的“微内核”关系不大。

  https://github.com/zephyrproject-rtos/zephyr/discussions/43472

  #quote(block: true, attribution: [ nashif, zephyr Maintainer])[
    zephyr is not based on the microkernel architecture... ]

  #quote(block: true, attribution: [doc/introduction/index.rst])[
    ...Both the application code and kernel code execute in a single shared
    address space... ]

  #quote(block: true, attribution: [doc/kernel/usermode/memory_domain.rst])[
    ...We do support some architectures, such as x86, which have a paged MMU,
    but in that case the MMU is used like an MPU with an identity page table...
   ]

  #quote(block: true, attribution: [
    Zephyr Project Hosted by Linux Foundation
   ])[
    ...Zephyr works on single address-space, where both the application and
    kernel are combined on a single image and execute in a single address-space;
    they like to call this feature as library-based RTOS (“kernel-less”) so
    there is no need for dynamic loading at run-time...
   ]

  http://events17.linuxfoundation.org/sites/events/files/slides/Zephyr%20Overview%20-%20OpenIOT%20Summit%202016.pdf

  #quote(block: true, attribution: [ Zephyr Project Overview ])[
    ...Static and single binary applications, Single address space, No loadable
    modules... ]

== 开发、构建

- 编程语言：c；

- 构建系统：west（python>=3.12 + cmake>=3.20.5）、ninja、Kconfig；

- 有posix c api兼容层，但并不完全兼容；

- 没有posix shell；

- 应用层部分有编程语言限制：

  只能用C/C++，且C++的部分语言特性缺失（thread、mutex相关的）；

== 项目规模

- 代码量：

  270万行左右

  ```bash
  cloc .
  # ...
  # Language     files blank  comment code
  # -----------------------------------------
  # C            8480  521289 305957  2196095
  # C/C++ Header 5117  104647 303575  490409
  # ...
  ```

- 裁剪预估：
  
  - x86编译qemu运行samples/posix/env

    实际上编译了的c源码+头文件约为（剔除空格和注释后）5万行左右。

== 基础设施

- 在x86_64环境中用qemu模拟cortex_a53可以正常拉起：

  ```bash
  west build -p always -b qemu_cortex_a53 samples/posix/env
  west build -t run
  ```

- openAMP支持完善：subsys/ipc/open-amp
  
  openAMP项目里有基于zephyr的例子：

  https://openamp.readthedocs.io/en/v2024.05.0/openamp-system-reference/examples/zephyr/README.html#rpmsg_multi_services/README.md

  https://events19.linuxfoundation.org/wp-content/uploads/2017/12/Linux-and-Zephyr-%E2%80%9CTalking%E2%80%9D-to-Each-Other-in-the-Same-SoC-Diego-Sueiro-Sepura-Embarcados.pdf

- 有同SoC，Zephyr和Linux混合部署的案例：

  https://www.nxp.com/docs/en/user-guide/UG10199.pdf

  #quote(block: true, attribution: [ NXP MPU Cortex-A Core Zephyr User Guide])[
    ...
    ==== 4.1.5.3 Booting Zephyr by using Linux RemoteProc
    
    Remoteproc (Remote Processor Framework) under Linux is another Cortex-A core
    Zephyr RTOS management tool in addition to the U-Boot commands in U-Boot.
    Using remoteproc can dynamically start or stop Zephyr... ]

