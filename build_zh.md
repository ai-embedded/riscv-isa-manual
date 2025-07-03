# RISC-V ISA 手册中文文档构建系统使用说明

## 📖 概述

本项目现在支持构建中文版和英文版的 RISC-V 指令集架构手册。通过 Docker 容器化构建系统，可以在任何支持 Docker 的机器上生成高质量的中文文档，包括 PDF、HTML 和 EPUB 格式。

## 🛠️ 系统要求

- **Docker**: 必须安装 Docker（推荐）
- **Git**: 用于代码管理和子模块更新
- **Make**: 用于执行构建命令

## 📁 项目结构

```
riscv-isa-manual/
├── src/                    # 英文源文件
├── src_zh/                 # 中文源文件
├── docs-resources/         # 共享资源（字体、主题、图片）
│   ├── fonts/             # 字体文件
│   └── themes/
│       ├── riscv-pdf.yml      # 英文 PDF 主题
│       └── riscv-pdf-zh.yml   # 中文 PDF 主题
├── build/                  # 构建输出目录
└── Makefile               # 构建配置文件
```

## 🚀 快速开始

### 1. 准备工作

```bash
# 克隆项目（包含子模块）
git clone --recurse-submodules https://github.com/your-repo/riscv-isa-manual.git
cd riscv-isa-manual

# 如果已经克隆，更新子模块
git submodule update --init --recursive
```

### 2. 检查 Docker 环境

```bash
# 检查 Docker 是否安装
docker --version

# 拉取最新的构建镜像
make docker-pull-latest
```

## 📚 构建命令详解

### 中文文档构建

```bash
# 构建所有中文格式（PDF + HTML + EPUB）
make build-zh

# 仅构建中文 PDF
make build-pdf-zh

# 仅构建中文 HTML  
make build-html-zh

# 仅构建中文 EPUB
make build-epub-zh
```

### 英文文档构建（保持不变）

```bash
# 构建所有英文格式
make build

# 仅构建英文 PDF
make build-pdf

# 仅构建英文 HTML
make build-html

# 仅构建英文 EPUB
make build-epub
```

### 组合构建

```bash
# 构建中英文所有格式
make build-all
```

### 指定文件构建

```bash
# 构建特定的中文文档
make build/riscv-privileged-zh.pdf      # 中文特权架构 PDF
make build/riscv-unprivileged-zh.html   # 中文非特权架构 HTML
make build/riscv-unprivileged-zh.epub   # 中文非特权架构 EPUB
```

## 📄 输出文件说明

构建完成后，文件将保存在 `build/` 目录下：

```
build/
├── riscv-privileged.pdf           # 英文特权架构手册
├── riscv-privileged-zh.pdf        # 中文特权架构手册
├── riscv-privileged-zh.html       # 中文特权架构网页版
├── riscv-unprivileged.pdf         # 英文非特权架构手册
├── riscv-unprivileged-zh.pdf      # 中文非特权架构手册
├── riscv-unprivileged-zh.html     # 中文非特权架构网页版
└── *.epub                         # EPUB 格式文件
```

## 🎨 文档格式特点

### PDF 版本
- **字体支持**: 专门配置的中文字体（Droid Sans Fallback、M+ 1p）
- **排版优化**: 适合中文阅读的行距和页面布局
- **图表支持**: 保持原有的技术图表和波形图
- **打印友好**: 高质量打印输出

### HTML 版本  
- **响应式设计**: 支持桌面和移动设备
- **交互导航**: 便于在线浏览和搜索
- **图片优化**: Web 优化的 SVG 图表
- **跨平台兼容**: 支持各种浏览器

### EPUB 版本
- **电子书格式**: 适合电子阅读器
- **自适应布局**: 支持字体大小调整
- **章节导航**: 完整的目录结构

## ⚠️ 注意事项

### 构建警告
中文构建过程中可能出现一些警告信息，这是正常现象：
```
asciidoctor: WARNING: unterminated literal block
asciidoctor: ERROR: dropping cell because it exceeds specified number of columns
```
这些警告不影响最终输出质量，构建系统已配置为容错处理。

### 字体渲染
- **Docker 环境**: 自动包含所需中文字体，确保一致渲染
- **本地环境**: 如果不使用 Docker，需要手动安装中文字体

### 性能优化
- **首次构建**: 需要下载 Docker 镜像，耗时较长
- **增量构建**: 后续构建会利用缓存，速度较快
- **并行构建**: 可以同时构建多种格式

## 🔧 高级用法

### 自定义构建选项

如需修改构建参数，可以编辑 `Makefile` 中的相关变量：

```makefile
# 中文构建选项
OPTIONS_ZH := --trace \
           -a compress \
           -a mathematical-format=svg \
           -a pdf-fontsdir=docs-resources/fonts \
           -a pdf-theme=docs-resources/themes/riscv-pdf-zh.yml \
           --failure-level=FATAL
```

### 清理构建文件

```bash
# 清理所有构建输出
make clean
```

### 子模块管理

```bash
# 检查子模块状态
make submodule-check

# 手动更新子模块
git submodule update --init --recursive
```

## 🐛 故障排除

### 常见问题

1. **Docker 权限问题**
   ```bash
   # 将用户添加到 docker 组
   sudo usermod -aG docker $USER
   # 重新登录使更改生效
   ```

2. **子模块未更新**
   ```bash
   git submodule update --init --recursive
   ```

3. **构建失败**
   ```bash
   # 拉取最新构建镜像
   make docker-pull-latest
   # 清理后重新构建
   make clean
   make build-zh
   ```

4. **中文字符显示问题**
   - 确保使用 Docker 构建（推荐）
   - 检查 PDF 查看器是否支持中文字体

### 错误级别说明

- **FATAL**: 仅致命错误会停止构建
- **ERROR**: 错误会被记录但不停止构建  
- **WARN**: 警告信息，不影响构建

## 📋 构建检查清单

在发布文档前，建议按以下清单检查：

- [ ] 成功构建所有格式（PDF、HTML、EPUB）
- [ ] 中文字符显示正常
- [ ] 图表和表格渲染正确
- [ ] 文档结构完整，目录导航正常
- [ ] 文件大小合理（参考：PDF 2-4MB，HTML 2-3MB）

## 🔄 版本控制

### Git 分支策略
- `main`: 稳定的英文版本
- `zh`: 中文翻译分支
- `develop`: 开发分支

### 构建流程
1. 更新中文源文件（`src_zh/`）
2. 提交更改到 `zh` 分支
3. 运行构建测试
4. 合并到主分支

## 📞 技术支持

如遇到问题，请按以下步骤：

1. **检查日志**: 查看完整的构建日志输出
2. **环境验证**: 确认 Docker 和依赖项正常
3. **文档查询**: 参考本说明和 README 文件
4. **问题反馈**: 提交 Issue 时请包含：
   - 操作系统信息
   - Docker 版本
   - 完整错误日志
   - 重现步骤

---

## 📈 性能指标

| 文档类型 | 构建时间 | 文件大小 | 页数 |
|---------|---------|---------|------|
| 中文 PDF | 3-5 分钟 | 2-4 MB | 200+ |
| 中文 HTML | 2-3 分钟 | 2-3 MB | - |
| 中文 EPUB | 2-4 分钟 | 1-2 MB | - |

**注**: 实际性能取决于硬件配置和网络环境。

---

*本文档随项目更新，如有疑问请参考最新版本或联系维护团队。*