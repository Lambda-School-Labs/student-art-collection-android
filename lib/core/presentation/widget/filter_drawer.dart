import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_filter_type.dart';
import 'package:student_art_collection/core/presentation/bloc/base_artwork_sort_type.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';

class FilterDrawer extends StatefulWidget {
  final Widget scaffold;
  final GlobalKey innerDrawerKey;
  final Function(
    List<FilterType> filterTypes,
    SortType sortType,
  ) onApplyPressed;

  FilterDrawer({
    this.scaffold,
    this.onApplyPressed,
    this.innerDrawerKey,
  });

  @override
  _FilterDrawerState createState() => _FilterDrawerState(
        innerDrawerKey,
        scaffold: scaffold,
        onApplyPressed: onApplyPressed,
      );
}

class _FilterDrawerState extends State<FilterDrawer> {
  final Widget scaffold;
  GlobalKey _innerDrawerKey;
  final Function(
    List<FilterType> filterTypes,
    SortType sortType,
  ) onApplyPressed;
  List<FilterType> selectedFilterTypes = [];
  SortType selectedSortType;

  _FilterDrawerState(
    GlobalKey key, {
    this.scaffold,
    this.onApplyPressed,
  }) {
    _innerDrawerKey = key;
  }

  List<String> sortLabels = [
    'Artwork Title Asc.',
    'Artwork Title Desc.',
    'Artist Name Asc.',
    'Artist Name Desc.',
    'Most Recent',
    'Oldest',
    'Most expensive',
    'Least Expensive',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InnerDrawer(
        key: _innerDrawerKey,
        rightChild: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 16),
            child: Column(
              children: <Widget>[
                Text(
                  'Filter',
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                  ),
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        style: TextStyle(
                          color: accentColorOnPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            color: accentColorOnPrimary,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColorOnPrimary,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: accentColorOnPrimary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 1,
                        bottom: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.clear,
                            color: accentColorOnPrimary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  'Sort',
                  style: TextStyle(
                    inherit: false,
                    fontSize: 24,
                  ),
                ),
                Divider(
                  color: accentColorOnPrimary,
                ),
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: accentColorOnPrimary,
                  ),
                  child: RadioButtonGroup(
                    onSelected: (label) {
                      selectedSortType = convertLabelToSortType(label);
                    },
                    labelStyle: TextStyle(
                      color: accentColorOnPrimary,
                      fontSize: 16,
                    ),
                    activeColor: accentColorOnPrimary,
                    labels: sortLabels,
                  ),
                ),
                Divider(
                  color: accentColorOnPrimary,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlineButton(
                      highlightedBorderColor: primaryColor,
                      splashColor: accentColorOnPrimary,
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: accentColorOnPrimary,
                        ),
                      ),
                      onPressed: () {
                        onApplyPressed(selectedFilterTypes, selectedSortType);
                      },
                      borderSide: BorderSide(
                        color: accentColorOnPrimary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onTapClose: true,
        swipe: true,
        colorTransition: primaryColor,
        proportionalChildArea: true,
        borderRadius: 4,
        leftAnimationType: InnerDrawerAnimation.static,
        rightAnimationType: InnerDrawerAnimation.quadratic,
        backgroundColor: primaryColor,
        innerDrawerCallback: (a) => print(a),
        scaffold: scaffold,
      ),
    );
  }
}
