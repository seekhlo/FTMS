import 'dart:io';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fms/components/flashbar.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import '../components/confirmation.dart';
import '../model/file.dart';
import '../requests.dart';
import 'editfilepage.dart';

class FilePage extends StatefulWidget {
  FilePage({Key? key, required this.link, required this.title})
      : super(key: key);
  String link;
  String title;

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  GlobalKey screenShotKey = GlobalKey();
  bool loader = true;
  Map<dynamic, dynamic>? files;
  List<dynamic>? table;
  var searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getPageData();
    // getFiles(widget.link)
    //     .then((value) => files = value)
    //     .whenComplete(() => setState(() {
    //           loader = false;
    //           table = files!['data'];
    //         }));
  }

  getPageData() {
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

  getButtons(var file, String title, String fileid) {
    List<Widget> buttons = [];
    if (title.toLowerCase().contains('new file') || title.toLowerCase().contains('completed file') ||title.toLowerCase().contains('inprocess file') ) {
      buttons.add(MaterialButton(
        child: Text("Print Barcode"),
        onPressed: () async {
          var data = await printBarcode(fileid);

          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text(data['FMTSFileTitle']),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              save(screenShotKey, data['FMTSFileBarcode']);
                            },
                            child: Text("Save")),
                        RepaintBoundary(
                          key: screenShotKey,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BarcodeWidget(
                                color: Colors.white,
                                data: data['FMTSFileBarcode'],
                                backgroundColor: Colors.black,
                                barcode: Barcode.code128(),
                                width: 300,
                                height: 100,
                                style: TextStyle(color: Colors.white),
                                decoration: const BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment(-0.5, -0.6),
                                    radius: 0,
                                    colors: <Color>[
                                      Color(0xFFEEEEEE),
                                      Color(0xFF111133),
                                    ],
                                    stops: <double>[0.9, 1.0],
                                  ),
                                ),
                                drawText: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
        },
      ));
      buttons.add(MaterialButton(
        child: Text("Edit File"),
        onPressed: () async {
          var status = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => EditFileForm(file)));
          print(status);
          if (status == true) {
            // reload page
            getPageData();
          }
        },
      ));
    }
    if (title.toLowerCase().contains('inprocess file') || title.toLowerCase().contains('completed file') ) {
      buttons.add(MaterialButton(
        child: Text("Archive File"),
        onPressed: () async {
          var status = await confirmationDialog(context);
          if (status == true) {
            await archiveFileAPI(file['FMTSFileID']);
            getPageData();
          }
        },
      ));
    }
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

  Future<File> takeScreenshot(screenShotKey, id) async {
    RenderRepaintBoundary boundary =
        screenShotKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final tempPath = (await getTemporaryDirectory()).path;
    final path = tempPath + id.toString() + ".png";
    File imgFile = File(path);
    return imgFile.writeAsBytes(pngBytes);
  }

  void save(screenShotKey, id) async {
    takeScreenshot(screenShotKey, id).then((value) async {
      bool? saved = await GallerySaver.saveImage(value.path);
      showSnackbar(msg: saved);
      Navigator.of(context).pop();
    }).catchError((onError) {
      showSnackbar(msg: onError);
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
              column.add(getButtons(file, widget.title, file['FMTSFileID']));
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
