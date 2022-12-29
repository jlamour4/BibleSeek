#firebase - backend as a service, BaaS

import time
import datetime
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import urllib.request

# fetch the service account key JSON file contents
cred = credentials.Certificate('serviceAccountKey.json')

start = time.time()
now = datetime.datetime.now()
print("ETL dump began at: ", now, '\n\n')
with urllib.request.urlopen('https://a.openbible.info/data/topic-votes.txt') as file:
    txt = file.read().decode('utf-8')

content = txt.split('\n', 1)[-1].split('\n')
jsonDict = {}

for line in content:
    splitLine = line.split('\t')
    topic = splitLine[0]
    if (len(topic) == 0 ):
        continue
    if topic not in jsonDict: 
        jsonDict[topic] = []
    jsonDict[topic].append({'startVerseId': splitLine[1], 'endVerseId': splitLine[2], 'votes': splitLine[3]})
    

# print(jsonDict['genealogy'])

# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://bibleseek-3ade5-default-rtdb.firebaseio.com/'
})

# save data
# ref = db.reference('topics/')

# for index, item in enumerate(jsonDict):
#     topicRef = ref.child(item)
#     topicRef.set(jsonDict[item])

ref = db.reference('topicsList/')
print(list(jsonDict.keys()))
ref.set(list(jsonDict.keys()))

end = time.time()
now = datetime.datetime.now()
print("ETL dump finished at: ", now, "\n\n")
print("Added ", len(jsonDict)," topics in ", (end - start), " seconds")


# # update data
# hopper_ref = topicRef.child('')
# hopper_ref.update({
    
# })

# read data
# handle = db.reference('topics/genealogy')

# added 6363 topics in 557.54 seconds