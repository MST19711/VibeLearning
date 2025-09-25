# 照片水印工具

一个使用Flutter构建的跨平台照片水印添加工具。

## 功能特性

- **批量处理**: 一次为多张照片添加水印
- **可自定义水印**:
  - 文本水印，支持自定义文字
  - 可调节透明度 (0-100%)
  - 可变大小控制
  - 颜色选择器选择文字颜色
  - 9个预定义位置 (左上、上中、右上、左中、中心、右中、左下、下中、右下)
- **文件管理**:
  - 选择多个图像文件
  - 选择输出目录或保存到与输入相同位置
  - 支持常见图像格式
- **用户友好界面**:
  - 简洁直观的设计
  - 水印设置实时预览
  - 处理过程中的进度指示
  - 关于对话框显示应用信息

## 截图

*截图将在此处添加*

## 安装

### 前提条件

- Flutter SDK (3.0或更高版本)
- Dart SDK
- Xcode (用于macOS开发)
- Git

### 从源代码构建

1. 克隆仓库:
```bash
git clone https://github.com/yourusername/photo_watermark.git
cd photo_watermark
```

2. 安装依赖:
```bash
flutter pub get
```

3. 为您的平台构建:

#### macOS
```bash
flutter build macos --release
```

构建的应用程序将位于 `build/macos/Build/Products/Release/photo_watermark.app`

#### 其他平台
```bash
# Windows
flutter build windows --release

# Linux
flutter build linux --release

# Web
flutter build web --release
```

## 使用方法

1. 启动应用程序
2. 点击"添加图像"选择要添加水印的照片
3. 配置水印设置:
   - 输入水印文本
   - 使用滑块调整透明度
   - 设置文本大小
   - 选择文本颜色
   - 选择水印位置
4. 选择输出目录 (可选 - 默认为输入文件位置)
5. 点击"处理图像"添加水印
6. 在输出目录中找到带水印的图像

## 开发

### 项目结构

```
lib/
├── main.dart                    # 主应用程序入口点
├── models/
│   └── app_state.dart          # 使用Provider的状态管理
├── screens/
│   └── main_screen.dart        # 主应用程序屏幕
└── widgets/
    ├── image_list.dart         # 图像选择和显示
    ├── watermark_controls.dart # 水印配置控件
    ├── output_directory_selector.dart # 输出目录选择
    └── process_button.dart     # 处理按钮控件
```

### 关键依赖

- `flutter`: UI框架
- `provider`: 状态管理
- `image`: 图像处理和水印
- `file_picker`: 文件选择对话框
- `path_provider`: 文件系统访问

### 贡献

1. Fork仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开拉取请求

## 许可证

本项目采用MIT许可证 - 有关详细信息，请参阅[LICENSE](LICENSE)文件。

## 致谢

- Flutter团队提供的优秀框架
- 图像处理库贡献者
- 文件选择器包维护者

## 支持

如果您遇到任何问题或有疑问，请在GitHub仓库上提交问题。

---

**使用Flutter ❤️ 制作**