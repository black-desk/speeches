#import "@preview/touying:0.7.1": *
#import themes.stargazer: *

#show: stargazer-theme.with(
  config-info(
    author: [陈麟轩],
    date: datetime.today(),
    contact: [chenlx163\@chinaunicom.cn],
  ),
)

#set text(
  lang: "zh",
  font: "Noto Serif CJK SC",
)

= LLM backporot 实践分享

== 怎么用

PR地址: https://git.culinux.net/ai/standard-skills/pulls/2

运行：

```bash
claude --plugin-dir /path/to/kbackport \
  "将 /path/to/reference/worktree 中的 COMMIT1..COMMIT2 backport 到 /path/to/target/worktree"
```

这两个目录需要是同一个git仓库的两个worktree。

== 背景

=== backport

- 跨版本移植特性

- 回迁修复补丁（CVE）

#pause

怎么做？

#pause

- 识别代码变动的意图，重写

- 可能需要回迁依赖

  - 依赖可能还有依赖

== 人怎么处理

- `cherry-pick -x`

#pause

- `git blame`

#pause

- `git log -S`

#pause

- 依赖排序

== 怎么让LLM处理：分析阶段

- 看 diff、源码、commit
  信息来变更的语义，提取里面用到了哪些符号（函数/宏）；

- 找出在目标分支不存在、不一致的符号；

- 去参考分支`git log -S`找符号的变动记录；

- 把需要backport的所有commit排序；

== 怎么让LLM处理：执行阶段

- 逐个 `cherry-pick`

  - 如果有冲突，解冲突

  - 验证编译

  - 缺少依赖、无法合理处理冲突时。打回到分析阶段。

== 插件结构

- skills

  - kbackport

- agents

  - commit-symbol-analyzer

  - symbol-availability-checker

  - symbol-origin-finder

  - backport-executor

== 问题

+ 为什么用agent

  - 长上下文降智

+ 为什么不用多级agent

  - claude code中为了防止agent调用递归，限制了agent不能调用agent

== 改进空间

+ 无法和agent交互

+ 记忆管理
