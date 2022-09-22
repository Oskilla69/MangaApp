genres = ['Cooking', 'Doujinshi', 'Fantasy', 'Gender bender', 'Harem', 'Historical', 'Horror', 'Isekai', 'Josei', 'Martial arts', 'Mature', 'Mecha', 'Medical', 'Mystery', 'One shot', 'Psychological', 'School life', 'Sci fi', 'Seinen', 'Shoujo', 'Shoujo ai', 'Shounen', 'Shounen ai', 'Slice of life', 'Sports', 'Supernatural', 'Tragedy', 'Yaoi', 'Yuri']

for genre in genres:
    print('const GENRE_' + genre.upper() + " = '" + genre + "';")

for genre in genres:
    print("GENRE_" + genre.upper().replace(" ", "_") + ',')