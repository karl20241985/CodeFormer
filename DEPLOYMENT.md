# CodeFormer 部署指南

## 🚀 快速开始

CodeFormer 现在支持多种部署方式，包括 Docker、GitHub Actions 和本地部署。

## 📦 部署方式

### 1. Docker 部署（推荐）

#### 使用 Docker Compose（最简单）
```bash
# 克隆仓库
git clone https://github.com/karl20241985/CodeFormer.git
cd CodeFormer

# 切换到部署分支
git checkout deploy

# 启动服务
docker-compose up -d
```

#### 使用 Docker 命令
```bash
# 构建镜像
docker build -t codeformer .

# 运行容器
docker run -d \
  -p 8000:8000 \
  -v $(pwd)/inputs:/app/inputs \
  -v $(pwd)/outputs:/app/outputs \
  -v $(pwd)/weights:/app/weights \
  codeformer
```

### 2. GitHub Actions 自动部署

每次推送到 `deploy` 分支时，GitHub Actions 会自动：
- 构建和测试应用
- 创建部署包
- 部署到 GitHub Pages
- 构建 Docker 镜像

### 3. 本地部署

#### 环境要求
- Python 3.8+
- CUDA 10.1+ (可选，用于GPU加速)
- 8GB+ RAM
- 5GB+ 磁盘空间

#### 安装步骤
```bash
# 克隆仓库
git clone https://github.com/karl20241985/CodeFormer.git
cd CodeFormer

# 创建虚拟环境
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 安装依赖
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install -r requirements.txt

# 下载预训练模型
python scripts/download_pretrained_models.py facelib
python scripts/download_pretrained_models.py CodeFormer
```

## 🎯 使用方法

### 面部修复
```bash
# 对于裁剪对齐的面部图像 (512x512)
python inference_codeformer.py -w 0.5 --has_aligned --input_path [图像路径]

# 对于完整图像
python inference_codeformer.py -w 0.7 --input_path [图像路径]
```

### 面部着色
```bash
python inference_colorization.py --input_path [图像路径]
```

### 面部修复
```bash
python inference_inpainting.py --input_path [图像路径]
```

## 🔧 配置选项

### 参数说明
- `-w`: 保真度权重，范围 [0, 1]
  - 较小值：更高质量
  - 较大值：更高保真度
- `--has_aligned`: 输入是否为裁剪对齐的面部
- `--bg_upsampler`: 背景增强器 (realesrgan)
- `--face_upsample`: 面部上采样

### Docker 环境变量
- `PYTHONPATH`: Python 路径
- `TORCH_HOME`: PyTorch 缓存目录

## 📁 目录结构
```
CodeFormer/
├── inputs/          # 输入图像
├── outputs/         # 输出结果
├── weights/         # 预训练模型
├── scripts/         # 工具脚本
├── web-demos/       # Web 演示
└── docs/           # 文档
```

## 🌐 Web 接口

部署后可以通过以下端口访问：
- `http://localhost:8000` - 基础服务
- `http://localhost:8001` - API 服务 (需要实现)
- `http://localhost:8080` - Web 界面 (需要实现)

## 🔒 安全建议

1. **限制文件上传大小**
2. **验证输入文件类型**
3. **使用 HTTPS 在生产环境**
4. **定期更新依赖包**
5. **监控资源使用情况**

## 📊 性能优化

### GPU 加速
```bash
# 使用 GPU 版本
docker run --gpus all -d codeformer
```

### 批处理
```bash
# 批量处理图像
python inference_codeformer.py --input_path [输入目录] --output_path [输出目录]
```

## 🐛 常见问题

### 内存不足
- 减少批处理大小
- 使用较小的输入图像
- 启用 CPU 模式

### CUDA 错误
- 检查 CUDA 版本兼容性
- 确保 GPU 驱动更新
- 考虑使用 CPU 模式

### 模型下载失败
- 检查网络连接
- 手动下载模型文件
- 使用代理服务器

## 📞 支持

如有问题，请在 GitHub Issues 中报告。

## 📄 许可证

本项目基于 NTU S-Lab License 1.0 发布。