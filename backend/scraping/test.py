import pickle
with open('chapter_list.pickle', 'wb') as f:
    queue = ['test', 'wow', ';lol']
    pickle.dump(queue, f)