# CocoaPodsTemplates
私有库自动生成模板

## Usage
### 下载模板
```shell
git clone https://github.com/SheriffWoody/cocoaPodsTemplate.git
```

### 创建私有pod 
1. GitHub上创建私有pod仓库

2. 进入CocoaPodsTemplates文件夹
cd CocoaPodsTemplates

3. 运行脚本
命令行输入：./config.py

4. 输入私有pod路径 直接回车默认与CocoaPodsTemplates同一层级

5. 输入项目名称

6. 输入SSH URL(在步骤一github页面上获取)

7. 输入作者，邮箱

8. 确认Y

9. 自动创建pod并提交git

### 编写pod
创建好的pod仓库有两个目录Actions和Core  
Actions中放路由Target_action  
Core中放模块源代码  
如果没有路由可以删除Action文件夹 删除podspec文件中相关部分

### 发布pod
发布之前 需要修改podspec中对应的version
#### 命令行发布
1. cd进入pod文件夹
2. 输入 ./push.sh 回车发布

#### 双击脚本发布
1. 进入pod文件夹
2. 右键push.sh文件-显示简介-打开方式修改为终端方式
3. 双击push.sh发布

## Author
Woody  hudi721@foxmail.com

## License

CocoaPodsTemplates is released under the MIT license.

