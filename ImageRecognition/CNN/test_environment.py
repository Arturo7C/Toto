# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 19:32:28 2019

@author: Arturo
"""

from PIL import Image
import time
	
time.sleep(5)
image = Image.open('dataset/Luna.JPG')
image.show()