import 'package:flutter/material.dart';
import 'package:mangaapp/shared/muhnga_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton(this.favouritesData, this.mangaId, {super.key});
  final List<dynamic> favouritesData;
  final int mangaId;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  final _supabase = Supabase.instance.client;
  late Color favouriteBackground;
  final favouritedColor = MuhngaColors.secondaryTint;
  final unfavouritedColor = MuhngaColors.secondary;
  @override
  void initState() {
    super.initState();
    if (widget.favouritesData.isNotEmpty) {
      favouriteBackground = favouritedColor;
    } else {
      favouriteBackground = unfavouritedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: favouriteBackground,
        child: SizedBox(
          height: 50.w,
          width: 50.w,
          child: IconButton(
              onPressed: () async {
                if (_supabase.auth.currentUser == null) {
                  Navigator.of(context).pushNamed('/login');
                } else {
                  if (favouriteBackground == favouritedColor) {
                    PostgrestResponse<dynamic> response =
                        await _supabase.from("favourites").delete().match({
                      'manga': widget.favouritesData[0]['manga'],
                      'user': _supabase.auth.currentUser!.id
                    }).execute();
                    if (response.hasError) {
                      print(response.error);
                    } else {
                      setState(() {
                        favouriteBackground = unfavouritedColor;
                      });
                    }
                  } else {
                    PostgrestResponse<dynamic> response = await _supabase
                        .from("favourites")
                        .insert({
                      'manga': widget.mangaId,
                      'user': _supabase.auth.currentUser!.id
                    }).execute();
                    if (response.hasError)
                      print(response.error);
                    else {
                      setState(() {
                        favouriteBackground = favouritedColor;
                      });
                    }
                  }
                }
              },
              icon: Icon(
                Icons.favorite,
                size: 25.0.w,
                color: MuhngaColors.heartRed,
              )),
        ));
  }
}
