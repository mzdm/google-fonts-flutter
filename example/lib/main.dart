import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Google Language Fonts Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final display1 =
        Theme.of(context).textTheme.headline5!.copyWith(fontSize: 30.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '\n❌ ďčažťtt ❌\n',
              style: GoogleFonts.getFont('Mada', textStyle: display1),
            ),
            Text(
              '✅ नमस्कार',
              style: DevanagariFonts.hind(textStyle: display1),
            ),
            Text(
              '✅ Здравствуйте',
              style: CyrillicFonts.robotoCondensed(textStyle: display1),
            ),
            Text(
              '✅️  مرحبا',
              style: ArabicFonts.mada(textStyle: display1),
            ),
            Text(
              '✅ 你好',
              style: ChineseSimplFonts.zcoolXiaoWei(textStyle: display1),
            ),
            Text(
              '✅ こんにちは',
              style: JapaneseFonts.mPlusRounded1c(textStyle: display1),
            ),
            Text(
              '✅ žluťoučký',
              style: CzechFonts.playfairDisplay(textStyle: display1),
            ),
          ],
        ),
      ),
    );
  }
}
