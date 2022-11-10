# -*- coding:UTF-8 -*-
import os
import sys, getopt

def build():
   print("....build flutter release....")
   os.system("cd ..")
   flag = os.system("flutter build  ios-framework --release")
   print("....build flutter release finished....")
   return flag

def copy():
    print("....copy ios flutter release framework to flutter_lib....")
    os.system("rm -rf ../FlutterLib/ios_frameworks/*")
    os.system("cp -rf build/ios/framework/Release/* ../FlutterLib/ios_frameworks/")

def pod():
    print("....main project pod install....")
    os.chdir("../oiocns-flutter")
    os.system("pod install")

def test():
    print("....main project pod install....")
    print(os.system("cd ../"))

def git_code():
    print("....push flutter to git....")
    os.chdir("../oiocns-flutter/")
    os.system("git add .")
    os.system('git commit -m \"flutter 内容更新\"')
    os.system("git push")
    print("....push flutter to git finished....")

def git_lib():
    os.chdir("../FlutterLib/")
    print("....push FlutterLib to git....")
    os.system("git add .")
    os.system('git commit -m \"flutter 内容更新\"')
    os.system("git push")
    print("....push flutter to git finished....")

def main(argv):
   try:
      opts, args = getopt.getopt(argv,"habcplt")
   except getopt.GetoptError:
      print 'test.py -[opts habcplt]'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print '-a all in b c p g'
         print '-b build ios framework'
         print '-c copy ios release framework to flutter_lib'
         print '-p pod main project pod install'
         print '-g push flutter_code to git'
         print '-l push flutter_lib to git'
         sys.exit()
      elif opt in ("-b"):
         build()
      elif opt in ("-c"):
         copy()
      elif opt in ("-p"):
         pod()
      elif opt in ("-l"):
         git_lib()
         print 'without'
      elif opt in ("-t"):
         git_code()
      elif opt in ("-a"):
         if build() == 0:
            copy()
            pod()
            git_code()
            git_lib()



if __name__ == "__main__":
   main(sys.argv[1:])