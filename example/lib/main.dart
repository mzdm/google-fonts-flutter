import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle display1 = Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('TODO'),
            Text(
              '❌ ýřččžýěíěš ❌\n',
              style: KhmerFonts.odorMeanChey(),
            ),
            // Text(
            //   '❌ ýřččžýěíěš ❌\n',
            //   style: GoogleFonts.kosugiMaru(textStyle: display1),
            // ),
            // Text(
            //   '✅ Здравствуйте',
            //   style: CyrillicFonts.robotoCondensed(textStyle: display1),
            // ),
            // Text(
            //   '✅️  مرحبا',
            //   style: ArabicFonts.mada(textStyle: display1),
            // ),
            // Text(
            //   '✅ žluťoučký',
            //   style: LatinExtFonts.playfairDisplay(textStyle: display1),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
