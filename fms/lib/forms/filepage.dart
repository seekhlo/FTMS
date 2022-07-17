import 'dart:io';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import '../model/file.dart';
import '../requests.dart';

class FilePage extends StatefulWidget {
  FilePage({Key? key, required this.link, required this.title})
      : super(key: key);
  String link;
  String title;

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  GlobalKey _screenShotKey = GlobalKey();
  bool loader = true;
  Map<dynamic, dynamic>? files;
  List<dynamic>? table;
  var searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    getFiles(widget.link)
        .then((value) => files = value)
        .whenComplete(() => setState(() {
              loader = false;
              table = files!['data'];
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: loader ? showLoader() : showList(),
    );
  }

  getButtons(String title, String fileid) {
    List<Widget> buttons = [];
    if (title.toLowerCase().contains('new file')) {
      buttons.add(MaterialButton(
        child: Text("Print Barcode"),
        onPressed: () async {
          var data = await printBarcode(fileid);

          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(data['FMTSFileTitle']),
                    content: RepaintBoundary(
                        key: _screenShotKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () {
                                  save(_screenShotKey, data['FMTSFileID']);
                                },
                                child: Text("Save")),
                            Center(
                              child: BarcodeWidget(
                                data: data['FMTSFileBarcode'],
                                barcode: Barcode.code128(),
                                width: 200,
                                height: 200,
                                drawText: false,
                              ),
                            ),
                          ],
                        )),
                  ));
        },
      ));
      buttons.add(MaterialButton(
        child: Text("Edit File"),
        onPressed: () {
          print("edit file page");
        },
      ));
    }
    // if (title.toLowerCase().contains('opened file')) {
    //   buttons.add(TextButton(
    //     child: Text("Print Barcode"),
    //     onPressed: () async {
    //       print("print barcode api");
    //     },
    //   ));
    //   buttons.add(TextButton(
    //     child: Text("Edit File"),
    //     onPressed: () {
    //       print("edit file page");
    //     },
    //   ));
    // }
    return Wrap(
      direction: Axis.horizontal,
      children: buttons,
    );
  }

  Future<File> takeScreenshot(_screenShotKey, id) async {
    RenderRepaintBoundary boundary =
        _screenShotKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final tempPath = (await getTemporaryDirectory()).path;
    final path = tempPath + id.toString() + ".png";
    File imgFile = File(path);
    return imgFile.writeAsBytes(pngBytes);
  }

  void save(_screenShotKey, id) async {
    takeScreenshot(_screenShotKey, id).then((value) async {
      bool? saved = await GallerySaver.saveImage(value.path);
      print(saved);
    }).catchError((onError) {
      print(onError);
    });
  }

  showList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            trailing: InkWell(
              child: const Icon(Icons.cancel),
              onTap: () {
                table = files!['data'];

                searchController.text = '';

                setState(() {});
              },
            ),
            title: TextField(
              onChanged: (value) {
                List<dynamic> t = files!['data'];
                var values = value.split(' ');
                if (value.isEmpty) {
                } else {
                  table = t.where((obj) {
                    var ele = obj.toString();
                    List<bool> flags = [];
                    for (var element in values) {
                      bool flag =
                          ele.toLowerCase().contains(element.toLowerCase());
                      flags.add(flag);
                    }
                    return !flags.contains(false);
                  }).toList();
                }
                setState(() {});
              },
              controller: searchController,
              decoration: const InputDecoration(
                label: Text("Search"),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: table!.length,
            itemBuilder: (context, index) {
              Map<dynamic, dynamic> file = table![index];
              List<Widget> column = [];

              file.forEach((key, value) {
                column.add(ListTile(
                  title: Center(
                    child: Text(
                      value,
                    ),
                  ),
                  leading: Text(
                    key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ));
              });
              column.add(getButtons(widget.title, file['FMTSFileID']));
              return Card(
                child: ExpansionTile(
                  children: column,
                  leading: Text("Title"),
                  title: Text(file['FMTSFileTitle']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  showLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
