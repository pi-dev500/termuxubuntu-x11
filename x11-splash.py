#!/usr/bin/env python3
from customtkinter import CTk, CTkLabel,CTkImage
from PIL import Image
from math import *
from time import sleep
import os
counter=0
root=CTk()
root.wm_attributes("-fullscreen",True)
height=root.winfo_screenheight()
imgp=Image.open("/usr/share/backgrounds/start.png")
img_x, img_y=imgp.size
image=CTkImage(light_image=imgp,dark_image=imgp,size=(ceil(height/img_y*img_x),height))
label_img=CTkLabel(root,image=image,text="")
label_img.place(relx=0.5, rely=0.5,anchor="center")
root.bind("<Escape>",lambda a :root.destroy())
def update(args=None):
    height=root.winfo_height()
    image.configure(size=(ceil(height/img_y*img_x),height))
root.bind("<Configure>",update)
root.after(10000,root.destroy)
while not os.path.exists("/tmp/started"):
    root.update()
    sleep(0.05)
    
root.destroy()