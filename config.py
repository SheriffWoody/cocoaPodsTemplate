#!/usr/bin/env python3

import os,shutil,stat

projectName="123"
httpsRepo=""
sshRepo=""
homePage=""
confirmed="n"
top_projectPath=os.path.abspath(os.path.dirname(os.getcwd()) + os.path.sep + ".")
projectPath=""
Author=""
Email=""
Example="n"
Language="Objc"

def getProjectPath():
    global projectPath
    projectPath = input("输入项目路径（输入回车默认与cocoapodsTemplate文件夹在同一目录下）:")
    if os.path.isdir(projectPath) == False:
        projectPath = ""

def getProjectName():
    global projectName
    projectName = input("输入项目名称:")

def getRepoUrl():
    global httpsRepo,sshRepo
    #httpsRepo = input("输入项目HTTP URL: ")
    sshRepo = input("输入项目SSH URL:")
    httpsRepo = sshRepo.replace("git@","http://")

def getHomePage():
    global homePage
#    homePage = input("输入项目主页URL(输入回车自动生成):")
    if homePage == '':
        homePage = httpsRepo.replace(".git","")
        homePage = homePage.replace("com:","com/")

def getAuthor():
    global Author
    global Email
    Author = input("输入项目作者:")
    Email = input("输入作者邮箱:")

def getProjectExample():
    global Example
    Example = input("\n是否创建Demo工程:y/n\n")
    if Example.lower() != 'y':
        return
    global Language
    Language = input("请输入想用哪种语言:[Objc / Swift]\n")
    if Language.lower() != "swift":
        Language = "Objc"
    else:
        Language = "Swift"
    print("=================================================================\n")
    print(" Project Language    :", Language)
    print("\n=================================================================")

def getConfig():
    getProjectPath()
    getProjectName()
    getRepoUrl()
    getHomePage()
    getAuthor()
    print("=================================================================\n")
    print(" Project Name    :",projectName)
    print(" HTTPS Repo      :",httpsRepo)
    print(" SSH Repo        :",sshRepo)
    print(" Home Page URL   :",homePage)
    print(" Author          :",Author)
    print(" Email           :",Email)
    print("\n=================================================================")

    getProjectExample()

#创建目录拷贝并模板文件
def createPathAndCopyFile():
    global projectPath
    if projectPath == "":
        projectPath = os.path.join(top_projectPath,projectName)
    else:
        projectPath = os.path.join(projectPath,projectName)
    Core=projectPath + "/" + projectName + "/Core"
    Actions=projectPath + "/" + projectName + "/Actions"
    os.makedirs(Core)
    os.makedirs(Actions)

    licenseFilePath = projectPath +"/LICENSE"
    specFilePath = projectPath +"/"+projectName+".podspec"
    readmeFilePath = projectPath +"/readme.md"
    pushFilePath = projectPath +"/push.sh"
    map={"__ProjectName__":projectName,"__HomePage__":homePage,"__Author__":Author,"__Email__":Email,"__SSHURL__":sshRepo}

    print("拷贝license文件")
    shutil.copyfile("./templates/LICENSE",licenseFilePath)

    print("拷贝podspec文件")
    shutil.copyfile("./templates/pod.podspec",specFilePath)
    fileSed(specFilePath,map)

    print("拷贝readme文件")
    shutil.copyfile("./templates/readme.md",readmeFilePath)
    fileSed(readmeFilePath,map)

    print("拷贝发布文件")
    shutil.copyfile("./templates/push.sh",pushFilePath) #后续修改成unix文件
    os.system("chmod +x %s"%pushFilePath)

    #为了保证文件夹不是空的 git add
    shutil.copyfile("./templates/.gitignore",Core+"/.gitignore")
    shutil.copyfile("./templates/.gitignore",Actions+"/.gitignore")

#创建demo
def configProjectDemo():
    sourceExamplePath = "./templates/" + Language + "/Example"
    targetExamplePath = projectPath + "/Example"
    os.makedirs(targetExamplePath)
    for f in os.listdir(sourceExamplePath):
        sourceF = os.path.join(sourceExamplePath, f)
        targetF = os.path.join(targetExamplePath, f)
        print(sourceF)
        print(targetF)
        if os.path.isfile(sourceF):
            shutil.copy(sourceF, targetF)
        if os.path.isdir(sourceF):
            shutil.copytree(sourceF, targetF)
    map = {"__ProjectName__": projectName}
    podfilePath = targetExamplePath + "/Podfile"
    fileSed(podfilePath,map)
    os.chdir(targetExamplePath)
    os.system("pod install")

#替换占位字符
def fileSed(filePath,map):
    with open(filePath, "r", encoding="utf-8") as f:
        # readlines以列表的形式将文件读出
        lines = f.readlines()
    with open(filePath, "w", encoding="utf-8") as f_w:
        for line in lines:
            for (key,value) in map.items():
                if key in line:
                    line = line.replace(key, value)
            f_w.write(line)

def gitInit():
    os.chdir(projectPath)
    os.system("git init")
    os.system("git remote add origin %s"%sshRepo)
    os.system("git add .")
    os.system("git commit -m init")
    os.system("git push --set-upstream origin master")


def start():
    global confirmed
    while (confirmed.lower() != 'y'):
        getConfig()
        confirmed = input("\n是否确认:y/n\n")

    createPathAndCopyFile()
    if Example.lower() == 'y':
        configProjectDemo()

    gitInit()


start()
