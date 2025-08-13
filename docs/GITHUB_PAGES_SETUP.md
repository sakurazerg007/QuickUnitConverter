# GitHub Pages 部署指南

本指南将帮助您将QuickUnitConverter的隐私政策托管到GitHub Pages，生成可公开访问的链接。

## 📋 准备工作

### 必需文件

确保您的仓库docs目录包含以下文件：

- ✅ `docs/privacy-policy.html` - HTML格式隐私政策
- ✅ `docs/privacy-policy.md` - Markdown格式隐私政策
- ✅ `docs/index.html` - 主页文件
- ✅ `docs/_config.yml` - Jekyll配置文件
- ✅ `docs/GITHUB_PAGES_SETUP.md` - 部署指南
- ✅ `README.md` - 项目说明文档（根目录）

## 🚀 部署步骤

### 步骤1：推送代码到GitHub

```bash
# 初始化Git仓库（如果还没有）
git init

# 添加所有文件
git add .

# 提交更改
git commit -m "Add privacy policy and GitHub Pages setup"

# 添加远程仓库（替换为您的仓库URL）
git remote add origin https://github.com/sakurazerg007/QuickUnitConverter.git

# 推送到GitHub
git push -u origin main
```

### 步骤2：启用GitHub Pages

1. 打开您的GitHub仓库页面
2. 点击 **Settings** 选项卡
3. 在左侧菜单中找到 **Pages** 选项
4. 在 **Source** 部分选择：
   - **Deploy from a branch**
   - **Branch**: `main` (或 `master`)
   - **Folder**: `/docs`
5. 点击 **Save** 保存设置

### 步骤3：等待部署完成

- GitHub Pages通常需要几分钟时间完成部署
- 部署完成后，您会在Pages设置页面看到绿色的成功提示
- 访问链接格式：`https://sakurazerg007.github.io/QuickUnitConverter/`

## 🔗 访问链接

部署完成后，您可以通过以下链接访问隐私政策：

### 主要链接

- **主页：** `https://sakurazerg007.github.io/QuickUnitConverter/`
- **隐私政策 (HTML)：** `https://sakurazerg007.github.io/QuickUnitConverter/privacy-policy.html`
- **隐私政策 (Markdown)：** `https://sakurazerg007.github.io/QuickUnitConverter/privacy-policy.md`

### 示例链接

假设您的GitHub用户名是 `johndoe`，仓库名是 `quickunitconverter`：

- **主页：** `https://johndoe.github.io/quickunitconverter/`
- **隐私政策：** `https://johndoe.github.io/quickunitconverter/privacy-policy.html`

## ⚙️ 自定义配置

### 更新_config.yml

编辑 `_config.yml` 文件，替换占位符：

```yaml
# 更新这些字段
url: "https://sakurazerg007.github.io"
baseurl: "/QuickUnitConverter"

# 示例
url: "https://johndoe.github.io"
baseurl: "/quickunitconverter"
```

### 更新index.html

在 `index.html` 文件中更新GitHub Pages URL：

```html
<p><strong>GitHub Pages URL：</strong></p>
<p><code>https://sakurazerg007.github.io/QuickUnitConverter/</code></p>
```

## 🔧 故障排除

### 常见问题

#### 1. 页面显示404错误

**解决方案：**
- 确保文件名正确（区分大小写）
- 检查GitHub Pages是否已启用
- 等待几分钟让部署完成

#### 2. 样式显示异常

**解决方案：**
- 检查CSS文件路径
- 确保`_config.yml`中的`baseurl`设置正确
- 清除浏览器缓存

#### 3. Jekyll构建失败

**解决方案：**
- 检查`_config.yml`语法是否正确
- 查看GitHub仓库的Actions选项卡中的错误信息
- 确保Markdown文件格式正确

### 检查部署状态

1. 在GitHub仓库页面，点击 **Actions** 选项卡
2. 查看最新的 **pages build and deployment** 工作流
3. 如果显示绿色勾号，说明部署成功
4. 如果显示红色叉号，点击查看错误详情

## 📱 在App Store中使用

### 隐私政策URL

在App Store Connect中提交应用时，使用以下URL作为隐私政策链接：

```
https://sakurazerg007.github.io/QuickUnitConverter/privacy-policy.html
```

### Apple审核要求

- ✅ 链接必须可公开访问
- ✅ 内容必须与应用实际行为一致
- ✅ 必须包含完整的隐私条款
- ✅ 支持移动设备访问

## 🔄 更新隐私政策

### 更新流程

1. 修改 `privacy-policy.html` 或 `privacy-policy.md` 文件
2. 更新版本号和最后修改日期
3. 提交并推送更改到GitHub
4. GitHub Pages会自动重新部署
5. 通常在几分钟内生效

### 版本控制

```bash
# 修改隐私政策后
git add privacy-policy.html privacy-policy.md
git commit -m "Update privacy policy v1.1"
git push origin main
```

## 📊 监控和分析

### GitHub Pages统计

- GitHub提供基本的访问统计
- 可在仓库的Insights > Traffic中查看

### 自定义域名（可选）

如果您有自己的域名，可以配置自定义域名：

1. 在仓库根目录创建 `CNAME` 文件
2. 文件内容为您的域名（如：`privacy.yourapp.com`）
3. 在域名DNS设置中添加CNAME记录指向GitHub Pages

## 📞 技术支持

如果在部署过程中遇到问题：

- 📖 查看[GitHub Pages官方文档](https://docs.github.com/en/pages)
- 📖 查看[Jekyll官方文档](https://jekyllrb.com/docs/)
- 📧 联系技术支持：support@quickunitconverter.com

---

**部署完成后，您的隐私政策将24/7可访问，满足App Store的要求！** 🎉