// ignore_for_file: constant_identifier_names

const GENRE_ROMANCE = 'Romance';
const GENRE_DRAMA = 'Drama';
const GENRE_COMEDY = 'Comedy';
const GENRE_ACTION = 'Action';
const GENRE_THRILLER = 'Thriller';
const GENRE_ADVENTURE = 'Adventure';
const GENRE_COOKING = 'Cooking';
const GENRE_DOUJINSHI = 'Doujinshi';
const GENRE_FANTASY = 'Fantasy';
const GENRE_GENDER_BENDER = 'Gender bender';
const GENRE_HAREM = 'Harem';
const GENRE_HISTORICAL = 'Historical';
const GENRE_HORROR = 'Horror';
const GENRE_ISEKAI = 'Isekai';
const GENRE_JOSEI = 'Josei';
const GENRE_MARTIAL_ARTS = 'Martial arts';
const GENRE_MATURE = 'Mature';
const GENRE_MECHA = 'Mecha';
const GENRE_MEDICAL = 'Medical';
const GENRE_MYSTERY = 'Mystery';
const GENRE_ONE_SHOT = 'One shot';
const GENRE_PSYCHOLOGICAL = 'Psychological';
const GENRE_SCHOOL_LIFE = 'School life';
const GENRE_SCI_FI = 'Sci fi';
const GENRE_SEINEN = 'Seinen';
const GENRE_SHOUJO = 'Shoujo';
const GENRE_SHOUJO_AI = 'Shoujo ai';
const GENRE_SHOUNEN = 'Shounen';
const GENRE_SHOUNEN_AI = 'Shounen ai';
const GENRE_SLICE_OF_LIFE = 'Slice of life';
const GENRE_SPORTS = 'Sports';
const GENRE_SUPERNATURAL = 'Supernatural';
const GENRE_TRAGEDY = 'Tragedy';
const GENRE_YAOI = 'Yaoi';
const GENRE_YURI = 'Yuri';

List<dynamic> GENRES = [
  GENRE_ROMANCE,
  GENRE_DRAMA,
  GENRE_COMEDY,
  GENRE_ACTION,
  GENRE_THRILLER,
  GENRE_ADVENTURE,
  GENRE_COOKING,
  GENRE_DOUJINSHI,
  GENRE_FANTASY,
  GENRE_GENDER_BENDER,
  GENRE_HAREM,
  GENRE_HISTORICAL,
  GENRE_HORROR,
  GENRE_ISEKAI,
  GENRE_JOSEI,
  GENRE_MARTIAL_ARTS,
  GENRE_MATURE,
  GENRE_MECHA,
  GENRE_MEDICAL,
  GENRE_MYSTERY,
  GENRE_ONE_SHOT,
  GENRE_PSYCHOLOGICAL,
  GENRE_SCHOOL_LIFE,
  GENRE_SCI_FI,
  GENRE_SEINEN,
  GENRE_SHOUJO,
  GENRE_SHOUJO_AI,
  GENRE_SHOUNEN,
  GENRE_SHOUNEN_AI,
  GENRE_SLICE_OF_LIFE,
  GENRE_SPORTS,
  GENRE_SUPERNATURAL,
  GENRE_TRAGEDY,
  GENRE_YAOI,
  GENRE_YURI,
];

List<dynamic> SORT_BY = [
  'Best Match',
  'Total Views',
  'Update Date',
  'Follows',
  'Favorites',
  'Rating',
];

// ignore: camel_case_types
enum SHARED_PREFERENCES { DATA_SAVER, VERTICAL_SCROLL, NOTIFICATIONS }

extension Parse on SHARED_PREFERENCES {
  String parse() {
    return toString().split('.').last;
  }
}

class MuhngaSpacing {
  static const double horizontalPadding = 18.0;
}
