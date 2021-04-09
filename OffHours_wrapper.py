import subprocess
import time
subjects = [1,2,3,4,5]
while len(subjects>0):
  qstat = subprocess.check_output(['qstat'],shell=True).decode().split('/bin/python')[0]
  que = len(qstat.split('\n'))-3
  time = time.localtime().tm_hour,time.localtime().tm_min 
  #check if there is room! 
  newsub = subjects.pop
  #submit code here
  time.sleep(60) #wait a minute

