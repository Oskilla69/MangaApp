import datetime
import json
import random

covers = [
        'gs://mangaapp-7bb62.appspot.com/One_Piece,_Volume_61_Cover_(Japanese).jpeg',
        'gs://mangaapp-7bb62.appspot.com/Tokyo_Ghoul_volume_1_cover.jpeg',
        'gs://mangaapp-7bb62.appspot.com/525.jpeg'
      ]
with open('./assets/manga_data.json', 'r+') as f:
    data = json.load(f)
    for i in data:
        i['cover'] = covers[random.randint(0, 2)]
        i['rating'] = float(i['rating'])
        i['last_updated_timestamp'] = datetime.datetime.strptime(i['last_updated'], "%Y-%m-%dT%H:%M:%S").timestamp()
    json.dump(data, f)