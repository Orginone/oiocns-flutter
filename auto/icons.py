# -*- coding:UTF-8 -*-
import os
import sys

def autoIcons():
    #icons根目录
    iconPath = 'assets/icons'
    #生成代码文件路径
    path = os.path.join('./lib/public/image', 'icons.dart')
    #打开文件
    outfile = open(path, mode='w')
    #写入代码
    outfile.write("class AIcons {")
    outfile.write("\n\tstatic Map<String, Map<String, String>> icons = {")
    #声明内容结果集
    icons = ""
    for home, dirs, files in os.walk(iconPath):
        #判断是否有2倍图放入2倍图集合
        if home.find("2.0x") >= 0:
            outfile.write('\n\t\t"2x": {')
        #判断是否有3倍图放入3倍图集合
        elif home.find("3.0x") >= 0:
            outfile.write('\n\t\t"3x": {')
        #无2x/3x区分的放入普通图集合
        else:
            outfile.write('\n\t\t"x": {')
        #遍历文件夹
        for filename in files:
            #判断是否是.png结尾
            if filename.endswith(".png"):
                #完整图片路径
                fullname = os.path.join(home, filename)
                fullname = fullname.replace("../", "").replace("\\", "/")
                #获取文件名称去除拓展名
                name = os.path.splitext(filename)[0]
                #拼接声明代码
                icon = '\n\tstatic const ' + name + ' = ' + '"' + name + '";'
                if icons.find(icon) == -1 :
                    icons += icon
                #拼接图集合
                if files[-1] != filename :
                    outfile.write('\n\t\t\t"'+name+'": "'+fullname+'",')
                else:
                    outfile.write('\n\t\t\t"'+name+'": "'+fullname+'"')
        #写入集合尾部代码
        outfile.write("\n\t\t},")

    outfile.write("\n\t};\n")
    #写入声明内容
    outfile.write(icons)
    #写入类尾部代码
    outfile.write("\n}\n")
    #关闭文件
    outfile.close()

    return

if __name__ == '__main__':
    autoIcons()