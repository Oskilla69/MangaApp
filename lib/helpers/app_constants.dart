const GENRE_ROMANCE = 'Romance';
const GENRE_DRAMA = 'Drama';
const GENRE_COMEDY = 'Comedy';
const GENRE_ACTION = 'Action';
const GENRE_THRILLER = 'Thriller';
const GENRE_ADVENTURE = 'Adventure';

List<dynamic> GENRES = [
  GENRE_ROMANCE,
  GENRE_DRAMA,
  GENRE_COMEDY,
  GENRE_ACTION,
  GENRE_THRILLER,
  GENRE_ADVENTURE,
];

List<dynamic> SORT_BY = [
  'Best Match',
  'Total Views',
  'Update Date',
  'Follows',
  'Bookmarks',
  'Rating',
];

enum SHARED_PREFERENCES { DATA_SAVER, VERTICAL_SCROLL, HORIZONTAL_SCROLL }

extension Parse on SHARED_PREFERENCES {
  String parse() {
    return toString().split('.').last;
  }
}
