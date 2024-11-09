import 'package:flutter/material.dart';
import 'header_widget.dart'; // Import the header widget
import 'main.dart';


//A stopperóra törzse. Egy szöveg ami a stopperórát mutatja, és egy lebegő gomb ami elindítja a stopperórát.
class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //Használjuk a header widgetet
          HeaderWidget(), 
          const Expanded(
            child: Center(
              child: Text(
                '00:00:00',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      //Lebegő gomb ami elindítja a stopperórát
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Majd ide kód
          print('Play Button Pressed');
        },
        // "Play" ikon a gomb közepére
        child: Icon(Icons.play_arrow, size: 32), 
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
