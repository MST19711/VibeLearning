# 照片水印工具

一个基于EXIF数据自动为照片添加日期水印的命令行工具。

## 🌟 功能特性

- 📸 从EXIF数据中提取日期信息
- 🎨 支持多种图片格式（JPG、PNG、BMP、TIFF）
- ✏️ 可自定义字体大小和颜色
- 📍 提供9个位置选项用于水印定位
- 📁 自动创建有组织的输出目录结构
- 🔲 添加文本轮廓以提高可见性
- ⚡ 现代化的UV依赖管理，安装快速可靠

## 🚀 安装方法

### 使用UV（推荐）

[UV](https://github.com/astral-sh/uv) 是一个快速的Python包安装器和解析器，性能优于pip。

1. **安装UV**（如果尚未安装）：
   ```bash
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   
   # 或者使用Homebrew（macOS）
   brew install uv
   
   # 或者使用pip
   pip install uv
   ```

2. **安装依赖并设置项目**：
   ```bash
   # 使用提供的安装脚本
   ./install_uv.sh
   
   # 或者手动操作
   uv sync
   ```

### 传统方法（使用pip）

1. 安装Python 3.8或更高版本
2. 安装所需依赖：
   ```bash
   pip install -r requirements.txt
   ```

## 📖 使用方法

### 使用UV（推荐）

安装UV后，您可以通过以下几种方式运行工具：

**选项1：使用`uv run`（推荐）**
```bash
# 基本用法
uv run photo_watermark.py /路径/到/照片

# 带选项使用
uv run photo_watermark.py /路径/到/照片 --font-size 64 --color red --position bottom-right

# 从任意目录运行
uv run --directory /路径/到/项目 photo_watermark.py /路径/到/照片
```

**选项2：激活虚拟环境**
```bash
# 激活虚拟环境
source .venv/bin/activate

# 然后正常使用
python photo_watermark.py /路径/到/照片
```

### 传统方法（使用pip）

基本用法：
```bash
python photo_watermark.py /路径/到/照片
```

带选项使用：
```bash
python photo_watermark.py /路径/到/照片 --font-size 64 --color red --position bottom-right
```

## ⚙️ 命令行参数

- `input_dir`：包含要添加水印照片的目录（必需）
- `--font-size`：水印字体大小（默认：48）
- `--color`：水印颜色选项：
  - 颜色名称：white, black, red, green, blue, yellow, cyan, magenta
  - 十六进制颜色：#FF0000（红色）
  - RGB格式：rgb(255,0,0)（红色）
- `--position`：水印位置（默认：bottom-right）：
  - top-left, top-center, top-right
  - center
  - bottom-left, bottom-center, bottom-right

## 💡 使用示例

**使用UV：**

1. 左上角白色水印：
   ```bash
   uv run photo_watermark.py ./vacation_photos --position top-left --color white
   ```

2. 中央大红色水印：
   ```bash
   uv run photo_watermark.py ./wedding_photos --font-size 72 --color red --position center
   ```

3. 自定义蓝色（十六进制）：
   ```bash
   uv run photo_watermark.py ./family_photos --color "#0066CC" --font-size 36
   ```

**使用传统pip：**

1. 左上角白色水印：
   ```bash
   python photo_watermark.py ./vacation_photos --position top-left --color white
   ```

2. 中央大红色水印：
   ```bash
   python photo_watermark.py ./wedding_photos --font-size 72 --color red --position center
   ```

3. 自定义蓝色（十六进制）：
   ```bash
   python photo_watermark.py ./family_photos --color "#0066CC" --font-size 36
   ```

## 📤 输出结果

- 创建名为`{原目录名}_watermark`的新目录作为子目录
- 处理输入目录中的所有支持的图片文件
- 跳过没有EXIF日期信息的文件
- 在输出目录中保持原始文件名

## 🖼️ 支持的图片格式

- JPEG（.jpg, .jpeg）
- PNG（.png）
- BMP（.bmp）
- TIFF（.tiff, .tif）

## 🔍 工作原理

1. 扫描指定目录中的图片文件
2. 从EXIF数据中提取日期信息（DateTimeOriginal、DateTime或DateTimeDigitized）
3. 将日期格式化为YYYY-MM-DD格式
4. 将日期作为水印添加到每张图片
5. 保存带水印的图片到新目录

## 📝 注意事项

- 工具将跳过没有EXIF日期信息的图片
- 水印包含微妙的轮廓，在各种背景上都能清晰可见
- 字体大小会根据图片尺寸自动调整
- 工具保持图片质量，JPG文件使用95%质量保存

## ⚠️ 错误处理

- 无效目录将显示错误信息
- 没有EXIF数据的图片将被跳过并显示通知
- 损坏的图片文件将被报告并跳过
- 缺失的字体将回退到系统默认字体

## 📂 项目结构

```
photo-watermark/
├── photo_watermark.py      # 主脚本
├── pyproject.toml          # UV项目配置
├── uv.lock                 # 锁定依赖
├── requirements.txt        # 传统pip依赖（回退方案）
├── install_uv.sh          # UV安装脚本
├── install.sh             # 传统pip安装脚本
├── README.md              # 英文文档
├── README.zh-CN.md        # 中文文档（本文件）
└── example_photos/        # 示例照片
```

## 🤔 为什么选择UV？

[UV](https://github.com/astral-sh/uv) 相比传统pip有以下几个优势：

- **⚡ 速度**：依赖解析和安装速度快10-100倍
- **🔒 可靠性**：使用锁定文件进行一致的依赖解析
- **💾 空间效率**：跨项目共享缓存
- **🚀 现代化**：内置虚拟环境管理
- **🌐 跨平台**：支持Windows、macOS和Linux

## 💻 开发

如果您想贡献或修改此工具：

1. **设置开发环境**：
   ```bash
   uv sync --extra dev
   ```

2. **使用开发依赖运行**：
   ```bash
   uv run --extra dev photo_watermark.py /路径/到/照片
   ```

3. **格式化代码**：
   ```bash
   uv run black photo_watermark.py
   ```

4. **运行测试**（如果已实现）：
   ```bash
   uv run pytest
   ```

## 📚 文档语言

- [English README](./README.md) - 英文文档
- [中文 README](./README.zh-CN.md) - 本文档（中文）

## 📝 许可证

MIT License - 详见项目根目录的LICENSE文件（如果存在）

## 🤝 贡献

欢迎提交问题报告和功能请求！请随时提交Pull Request。

## 📞 支持

如果您遇到问题或有疑问：
1. 查看本README文档
2. 使用 `--help` 参数查看命令行选项
3. 检查是否有EXIF数据的图片
4. 确保图片格式受支持

---

**注意**：此工具设计用于处理包含EXIF日期信息的照片。如果您的照片没有EXIF数据，工具会跳过这些文件并显示通知。这是正常行为，不是错误。