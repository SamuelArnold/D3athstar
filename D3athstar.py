#!/usr/bin/python
import string
import os
import git
print ("##############")
print ("D3athStar ver 0.01")
print ("##############")

user = raw_input("Enter your name: ")
print ("Hello", user)
print ("Input 1: For Setup Libraries")

myinput  =raw_input("Input: ")

if (myinput == "1"):
	git.Git().clone("git://gitorious.org/git-python/mainline.git")
