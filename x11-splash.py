#!/usr/bin/env python3
from tkinter import Tk, Label
from PIL import Image, ImageTk
from math import *
from time import sleep
import os
import sys
counter=0
root=Tk()
root.wm_attributes("-fullscreen",True)
height=root.winfo_screenheight()
imgp=Image.open("/usr/share/backgrounds/start.png")
img_x, img_y=imgp.size
imgp=imgp.resize((ceil(height/img_y*img_x),height))
image=ImageTk.PhotoImage(imgp)
label_img=Label(root,image=image)
label_img.place(relx=0.5, rely=0.5,anchor="center")
root.bind("<Escape>",lambda a :root.destroy())
oldheight=height
while (counter<=100 and not os.path.exists("/tmp/started")):
    root.update()
    oldheight, height=height,root.winfo_height()
    if oldheight!=height:
        os.system(sys.argv[0])
        quit(0)
    sleep(0.1)
    counter+=1
quit(0)