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

= LLM backporot skill 实践分享

== 怎么用

PR地址: https://git.culinux.net/ai/standard-skills/pulls/2

运行：

```bash
git clone https://git.culinux.net/ai/standard-skills # PR 合并后
claude --plugin-dir "/path/to/standard-skills/kbackport" \
  "帮我将/path/to/reference目录中的 \
  c369299895a591d96745d6492d4888259b004a9e..HEAD backport到/path/to/target"
```

---

```
❯ 帮我将 linux目录中的c369299895a591d96745d6492d4888259b004a9e..HEAD            
  backport到chinaunicom/linux+io_uring_bpf_ops                                  

...

  Backport 计划：36 个 commit

  Regions 基础设施 (32 个 prerequisite):
  1. 3ab1db3c6039 - get rid of remap_pfn_range()
  2. 87585b05757d - use vm_insert_pages() for pbuf ring
  3. 18595c0a58ae - use unpin_user_pages()
  4. f15ed8b4d0ce - move mapping helpers to memmap.c
  5. 6b231248e97f - consolidate overflow flushing
  6. 200f3abd14db - move eventfd to eventfd.c
  7. c3ac76f9ca7a - add remote task_work execution helper
  8. 0b6d253e084a - provide helper to get ctx from fd
  9. 09d0a8ea7fac - move max entry definition into header
  10. 81d8191eb99d - abstract out ring filling logic
  11. d090bffab609 - return -EFAULT for mmap on NULL rings
  12. 79cfe9e59c2a - add IORING_REGISTER_RESIZE_RINGS
  13. dfbbfbf19187 - introduce concept of memory regions
  14. 93238e661855 - add memory region registration
  15. 943d0609d057 - rename ->resize_lock
  16-24. 9个 memmap 系列优化 commit
  16. 087f997870a9 - implement mmap for regions
  17. 02255d55260a - pass ctx to io_register_free_rings
  18. 8078486e1d53 - use region api for SQ
  19. 81a4058e0cd0 - use region api for CQ
  29-31. kbuf region commits
  20. 4aed5b4e6d27 - add helper calculating region byte size

  Target commits (4 个):
  33. 4a4b64f4cb51 - callback driven main loop
  34. 9cd9e392e366 - bpf-ops loop_step
  35. d009b5fb9f92 - kfunc helpers
  36. d1e9b8578912 - bpf ops registration

● User answered Claude's questions:
  ⎿  · 确认开始执行 36 个 commit 的 backport？ → 确认，开始执行

● 开始执行全部 36 个 commit 的 backport。

● Phase 1 已批准，直接进入 Phase 3。开始从 commit #1 执行全部 36 个 commit。

  #1/36 3ab1db3c6039 - io_uring: get rid of remap_pfn_range() for mapping
  rings/sqes

● backport-executor(Backport #1: 3ab1db3c)
  ⎿  Done (30 tool uses · 27.3k tokens · 5m 8s)
  (ctrl+o to expand)

...

● 全部 36/36 个 commit backport 完成！最终验证：

● Bash(git log --oneline -36)
  ⎿  f73df093182a io_uring/bpf-ops: implement bpf ops registration
     429855c38736 io_uring/bpf-ops: add kfunc helpers
     dab3ea44494e io_uring/bpf-ops: implement loop_step with BPF struct_ops
     … +29 lines (ctrl+o to expand)

● 36/36 commits backport 全部完成！ 最终编译通过。

  汇总：
  - Regions 基础设施: 32 个 commit（#1-#32），从 remap_pfn_range 移除到完整的
  region API
  - Target commits: 4 个 commit（#33-#36），callback driven main loop + BPF
  struct_ops + kfunc helpers + bpf ops registration
  - 所有 commit 编译通过，目标分支 linux+io_uring_bpf_ops 现在包含完整的
  io_uring BPF ops 支持

```

== 背景

=== 什么时候需要backport

- 跨版本移植特性

- 回迁修复补丁（CVE）

#pause

怎么做？

#pause

- 识别代码变动的意图，重写

- 可能需要回迁依赖

  #pause

  - 依赖可能还有依赖

== 人怎么处理

#pause

- `cherry-pick -x`

#pause

- `git blame`

#pause

- `git log -S`

#pause

- 依赖排序

== 怎么让LLM处理

- 看 diff、源码、commit
  信息来变更的语义，提取里面用到了哪些符号（函数/宏）；

#pause

- 找出在目标分支不存在、不一致的符号；

#pause

- 重读需要backport的commit，分析上述符号对特性是否有影响；

#pause

- 去参考分支`git log -S`找符号的变动记录；

#pause

- 逐个分析上述过程获得的commit进行backport的必要性；

#pause

- 对需要backport的所有commit做拓扑排序；

---

- 逐个 `cherry-pick`

  - 如果有冲突，解冲突

  - 验证编译

  - 发现缺少依赖、无法合理处理冲突时。打回到分析阶段。

== 插件结构

- skills

  - kbackport

- agents

  - commit-symbol-analyzer 分析使用的符号

  - symbol-availability-checker 分析符号的缺失

  - dependency-analyzer 分析符号的必要性

  - symbol-origin-finder 分析符号变动记录

  - backport-executor 逐个提交解决冲突

== 问题

- 为什么不简单地用多个skill组织任务？

  - 长上下文时，模型降智明显，而agent有独立的上下文；

  - 任务拆太碎效果也未必好，需要尝试；
  
- 为什么不用多级agent

  - claude code为了防止agent调用递归，限制了agent不能调用agent


== 改进空间

- 目前没有找到合适的方法和subagent交互、观察subagent正在做什么

- API限流、网络问题

== 提示词怎么写？

- 给出示例输出、大致流程、目的；

- 不需要写每一步具体怎么做；

- 参考资料不要嵌入提示词里。
