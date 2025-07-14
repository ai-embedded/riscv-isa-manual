# RISC-V ISA Manual 翻译准确性详细检查报告

## 1. zabha.adoc 详细对比

### 标题
- **英文**: "Zabha" Extension for Byte and Halfword Atomic Memory Operations, Version 1.0
- **中文**: "Zabha"——字节和半字原子内存操作扩展，版本 1.0
- **状态**: ✅ 准确

### 第一段
- **英文**: The A-extension offers atomic memory operation (AMO) instructions for _words_, _doublewords_, and _quadwords_ (only for `AMOCAS`).
- **中文**: A 扩展为"字"、"双字"和"四字"（仅适用于 `AMOCAS`）提供了原子内存操作 (AMO) 指令。
- **状态**: ✅ 准确

### 第一段（续）
- **英文**: The absence of atomic operations for subword data types necessitates emulation strategies.
- **中文**: 由于缺少对子字数据类型的原子操作，因此需要采用模拟策略。
- **状态**: ✅ 准确

### 第一段（续）
- **英文**: For bitwise operations, this emulation can be performed via word-sized bitwise AMO* instructions.
- **中文**: 对于位操作，可以通过字大小的位操作 AMO* 指令来执行此模拟。
- **状态**: ✅ 准确

### 第一段（续）
- **英文**: For non-bitwise operations, emulation is achievable using word-sized `LR`/`SC` instructions.
- **中文**: 对于非位操作，可以使用字大小的 `LR`/`SC` 指令来实现模拟。
- **状态**: ✅ 准确

### "Several limitations arise from this emulation approach:"
- **英文**: Several limitations arise from this emulation approach:
- **中文**: 这种模拟方法会带来一些限制：
- **状态**: ✅ 准确

### 限制1
- **英文**: In systems with large-scale or Non-Uniform Memory Access (NUMA) configurations, emulation based on `LR`/`SC` introduces issues related to scalability and fairness, particularly under conditions of high contention.
- **中文**: 在具有大规模或非统一内存访问 (NUMA) 配置的系统中，基于 `LR`/`SC` 的模拟会引入与可伸缩性和公平性相关的问题，尤其是在高争用条件下。
- **状态**: ✅ 准确

### 限制2
- **英文**: Emulation of narrower AMOs through wider AMO* instructions on non-idempotent IO memory regions may result in unintended side effects.
- **中文**: 在非幂等 IO 内存区域上通过更宽的 AMO* 指令模拟更窄的 AMO 可能会导致意外的副作用。
- **状态**: ✅ 准确

### 限制3
- **英文**: Utilizing wider AMO* instructions for emulating narrower AMOs risks activating extraneous breakpoints or watchpoints.
- **中文**: 使用更宽的 AMO* 指令来模拟更窄的 AMO 会有激活无关断点或观察点的风险。
- **状态**: ✅ 准确（"extraneous"翻译为"无关"是合适的）

### 限制4
- **英文**: In the absence of native support for subword atomics, compilers often resort to inlining code sequences to provide the required emulation. This practice contributes to an increase in code size, with consequent impacts on system performance and memory utilization.
- **中文**: 在缺少对子字原子操作的本机支持的情况下，编译器通常会采用内联代码序列来提供所需的模拟。这种做法会导致代码大小增加，从而对系统性能和内存利用率产生影响。
- **状态**: ✅ 准确

### Zabha扩展介绍
- **英文**: The Zabha extension addresses these limitations by adding support for _byte_ and _halfword_ atomic memory operations to the RISC-V Unprivileged ISA. The Zabha extension depends upon the Zaamo standard extension.
- **中文**: Zabha 扩展通过向 RISC-V 非特权 ISA 添加对"字节"和"半字"原子内存操作的支持来解决这些限制。Zabha 扩展依赖于 Zaamo 标准扩展。
- **状态**: ✅ 准确

### 章节标题
- **英文**: === Byte and Halfword Atomic Memory Operation Instructions
- **中文**: === 字节和半字原子内存操作指令
- **状态**: ✅ 准确

### 指令说明
- **英文**: Zabha extension provides the `AMO[ADD|AND|OR|XOR|SWAP|MIN[U]|MAX[U]].[B|H]` instructions. If Zacas extension is also implemented, Zabha further provides the `AMOCAS.[B|H]` instructions.
- **中文**: Zabha 扩展提供了 `AMO[ADD|AND|OR|XOR|SWAP|MIN[U]|MAX[U]].[B|H]` 指令。如果还实现了 Zacas 扩展，Zabha 还将提供 `AMOCAS.[B|H]` 指令。
- **状态**: ✅ 准确

### Wavedrom图表
- **状态**: ✅ 完全相同

### 符号扩展说明
- **英文**: Byte and halfword AMOs always sign-extend the value placed in `rd`, and ignore the stem:[XLEN-1:2^{(width + 3)}] bits of the original value in `rs2`. The `AMOCAS.[B|H]` instructions similarly ignore the stem:[XLEN-1:2^{(width + 3)}] bits of the original value in `rd`.
- **中文**: 字节和半字 AMO 总是对放入 `rd` 的值进行符号扩展，并忽略 `rs2` 中原始值的 stem:[XLEN-1:2^{(width + 3)}] 位。`AMOCAS.[B|H]` 指令同样忽略 `rd` 中原始值的 stem:[XLEN-1:2^{(width + 3)}] 位。
- **状态**: ✅ 准确

### 对齐要求
- **英文**: Similar to the AMOs specified in the A extension, the Zabha extension mandates that the address contained in the `rs1` register must be naturally aligned to the size of the operand. The same exception options as specified in the A extension are applicable in cases where the address is not naturally aligned.
- **中文**: 与 A 扩展中指定的 AMO 类似，Zabha 扩展要求 `rs1` 寄存器中包含的地址必须与操作数的大小自然对齐。在地址未自然对齐的情况下，适用与 A 扩展中指定的相同的异常选项。
- **状态**: ✅ 准确

### 一致性语义
- **英文**: Similar to the AMOs specified in the A and Zacas extensions, the AMOs in the Zabha extension optionally provide release consistency semantics, using the `aq` and `rl` bits, to help implement multiprocessor synchronization.
- **中文**: 与 A 和 Zacas 扩展中指定的 AMO 类似，Zabha 扩展中的 AMO 可选择性地提供释放一致性语义，使用 `aq` 和 `rl` 位来帮助实现多处理器同步。
- **状态**: ✅ 准确

### 最后的NOTE
- **英文**: Zabha omits _byte_ and _halfword_ support for `LR` and `SC` due to low utility.
- **中文**: 由于效用较低，Zabha 省略了对 `LR` 和 `SC` 的"字节"和"半字"支持。
- **状态**: ✅ 准确

## 总结
zabha.adoc 已经完成100%准确翻译，并已删除额外内容。

## 2. zacas.adoc 详细对比

### 主要修改
1. **删除额外内容**: 删除了从第181行开始的所有额外章节（软件使用考虑、实现指导、调试和验证）
2. **修正翻译错误**: 
   - 第170行：将"额外的 AMO PMA"修正为"额外的 AMO PMAs"（保持复数形式）

### 翻译质量评估
- 整体翻译质量优秀，技术术语翻译准确
- 代码示例和注释翻译完整
- 现已与英文版100%对应（259行）

## 3. zawrs.adoc 详细对比

### 主要修改
1. **删除额外内容**: 删除了从第59行开始的所有额外内容（代码示例、体系结构状态、实现指导原则、与其他扩展的交互）

### 翻译质量评估
- 整体翻译准确，技术术语恰当
- 现已与英文版100%对应（103行）