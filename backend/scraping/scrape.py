import json
import signal
from time import time
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common import by
import random
from datetime import datetime, timedelta
import pickle
from pathlib import Path

def handle_timeout(sig, frame):
    raise TimeoutError('Timeout')

def scrape():
    driver = webdriver.Chrome(ChromeDriverManager().install())
    signal.signal(signal.SIGALRM, handle_timeout)

    driver.get('https://manganato.com/')

    manga_titles = driver.find_elements(by.By.CLASS_NAME, 'item-title')
    manga_author = driver.find_elements(by.By.CLASS_NAME, 'item-author')
    manga_ratings = driver.find_elements(by.By.CLASS_NAME, 'item-rate')
    links = []
    titles = []
    authors = []
    ratings = []
    mangas = []
    synopsises = ["""A wealthy man, Kurosu Tokimune, meets an unnatural end.
With his death, his family joins together to grieve, only to become suspects of a police investigation as to whether he was murdered.
Their primary suspect: the adopted daughter of the Kurosu family and first to discover his body, Kurosu Tokiko. The girl who shows no distress at her father's death.
And as all suspicions point to her, the second unnatural death occurs...
It's always been this way.
Wherever Tokiko goes, people tend to die.""", 'haha cool this is a synopsis xd! blah blah blah blah blah blah blah blha blah blah.']

    statuses = ['ongoing', 'completed', 'hiatus']
    genres = ['Action', 'Adventure', 'Comedy', 'Mature', 'Fantasy', 'Historical', 'Romance', 'Sports', 'Mystery', 'Sci-fi', 'Drama', 'Ecchi', 'Harem', 'Horror', 'Josei', 'Martial Arts', 'Mecha', 'Music', 'Psychological', 'Romance', 'School Life', 'Shoujo', 'Shoujo Ai', 'Shounen', 'Shounen Ai', 'Slice of Life', 'Supernatural', 'Tragedy', 'Yaoi', 'Yuri']

    for idx, manga in enumerate(manga_titles):
        links.append(manga.find_element(by.By.CSS_SELECTOR, 'a').get_attribute('href'))

        titles.append(manga.find_element(by.By.CSS_SELECTOR, 'a').text)
        authors.append(manga_author[idx].text)
        ratings.append(manga_ratings[idx].text)

    with open('manga_data.json', 'w+') as f:
        print(len(titles))
        for idx, title in enumerate(titles):
            try:
                signal.alarm(25)
                link = links[idx]
                print(str(idx) + ': ' + link)
                author = authors[idx]
                rating = ratings[idx]
                print('aaaa')
                synopsis = synopsises[random.randint(0, 1)]
                print('bbb')
                mangas.append({'title': title, 'author': author, 'rating': ratings[idx], 'synopsis': synopsis, 'status': statuses[random.randint(0, 2)], 'genre': [genres[random.randint(0, len(genres) - 1)], genres[random.randint(0, len(genres) - 1)], genres[random.randint(0, len(genres) - 1)]], 'views': random.randint(100000, 10000000), 'last_updated': (datetime.now() - timedelta(random.randint(0, 50))).strftime('%Y-%m-%d %H:%M:%S')})
            except Exception as e:
                print(e)
        f.write(json.dumps(mangas))

        with open('manga_data.pickle', 'wb') as fp:
            pickle.dump(mangas, fp)

scrape()

# if not Path('chapter_list.pickle').exists():
#     print('Creating chapter list pickle')
#     chapters = driver.find_elements(by.By.CLASS_NAME, 'item-chapter')

#     queue = []
#     print(len(chapters))
#     for title in manga_titles:
#         for idx in range(0, len(chapters), 3):
#             chap_3 = chapters[idx].find_element(by.By.CSS_SELECTOR, 'a').get_attribute('href')
#             chap_2 = chapters[idx+1].find_element(by.By.CSS_SELECTOR, 'a').get_attribute('href')
#             chap_1 = chapters[idx+2].find_element(by.By.CSS_SELECTOR, 'a').get_attribute('href')
#             queue.append(chap_3)
#             queue.append(chap_2)
#             queue.append(chap_1)
#     print('creating...')
#     with open('chapter_list.pickle', 'wb') as f:
#         pickle.dump(queue, f)

# with open('chapter_list.pickle', 'rb') as f:
#     queue = pickle.load(f)

# count = 0
# while len(queue) > 0:
#     curr_manga = manga_titles[count // 3].text
#     chapter_idx = count % 3
#     chapter = driver.get(queue.pop(0))
#     chapter_imgs = driver.find_elements(by.By.CLASS_NAME, 'container-chapter-reader')
#     for idx, img in enumerate(chapter_imgs):
#         url = img.find_element(by.By.CSS_SELECTOR, 'img').get_attribute('src')
#         urllib.request.urlretrieve(url, './manga/' + curr_manga + '/' + str(chapter_idx) + '/' + str(idx) + '.jpg')
#     count += 1



# with open('manga_data.json', 'w+') as f:
#     f.write('{')
#     for idx, img in enumerate(manga_imgs):
#         f.write(json.dumps({'img': img.get_attribute('src'), 'title': manga_titles[idx].text, 'author': manga_author[idx].text, 'rating': manga_ratings[idx].text}))

#     f.write('}')