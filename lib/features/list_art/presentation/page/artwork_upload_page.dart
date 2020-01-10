import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';
import 'package:student_art_collection/core/util/functions.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/upload/artwork_upload_state.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';

import '../../../../service_locator.dart';

class ArtworkUploadPage extends StatelessWidget {
  static const String ID = 'school_artwork_detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArtworkUploadBloc>(
      create: (context) => sl<ArtworkUploadBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocListener<ArtworkUploadBloc, ArtworkUploadState>(
          listener: (context, state) {},
          child: UploadWidget(),
        ),
      ),
    );
  }
}

class UploadWidget extends StatefulWidget {
  @override
  _UploadWidgetState createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  String title, artistName, description;
  bool sold;
  int category, price;

  DateTime selectedDate = DateTime.now();

  final dateTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final categoryTextController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateTextController.text = formatDate(selectedDate);
      });
  }

  _showPricePicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: _getPrices(),
        ),
        changeToFirst: false,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            priceTextController.text =
                pickerValueToPureValue(picker.adapter.text);
            price = pricePickerValueToInt(
                pickerValueToPureValue(picker.adapter.text));
          });
        });
    picker.showModal(context);
  }

  _showCategoryPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
          pickerdata: _getCategories(),
        ),
        changeToFirst: false,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            final temp = _getCategories().indexOf(
                  pickerValueToPureValue(picker.adapter.text),
                ) +
                1;
            category = temp;
            categoryTextController.text = pickerValueToPureValue(
              picker.adapter.text,
            );
          });
        });
    picker.showModal(context);
  }

  List<String> _getPrices() {
    return [
      '\$5',
      '\$10',
      '\$15',
      '\$20',
      '\$25',
      '\$30',
      '\$35',
      '\$40',
      '\$45',
      '\$50',
    ];
  }

  List<String> _getCategories() {
    return [
      'Photography',
      'Drawing',
      'Painting',
      'Sculpture',
      'Other',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                flex: 4,
                child: Container(
                  color: Colors.blue,
                ),
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.loose,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: getAuthInputDecoration('Enter Artwork Title'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        artistName = value;
                      },
                      decoration: getAuthInputDecoration('Enter Student Name'),
                    ),
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select Date Created'),
                          controller: dateTextController,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.date_range,
                                color: accentColor,
                              ),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select Artwork Price'),
                          controller: priceTextController,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.attach_money,
                                color: accentColor,
                              ),
                              onPressed: () {
                                _showPricePicker(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          decoration:
                              getAuthInputDecoration('Select Artwork Category'),
                          controller: categoryTextController,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.category,
                                color: accentColor,
                              ),
                              onPressed: () {
                                _showCategoryPicker(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            dispatchUpload();
                          },
                          color: accentColor,
                          textColor: Colors.white,
                          child: Text(
                            'Submit',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dispatchUpload() {
    BlocProvider.of<ArtworkUploadBloc>(context).add(UploadNewArtworkEvent(
        category: 1,
        price: 20,
        sold: false,
        title: 'Android Test Art',
        artistName: 'Test Student',
        description: 'Test description',
        imageUrls: [
          'https://images.pexels.com/photos/102127/pexels-photo-102127.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=940',
          'https://images.pexels.com/photos/2303796/pexels-photo-2303796.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
          'https://images.pexels.com/photos/459225/pexels-photo-459225.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
        ]));
  }
}
