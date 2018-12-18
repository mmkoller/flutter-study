import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const _REQUEST = "https://api.hgbrasil.com/finance?key=2851ecca";

void main() async {
  runApp(MaterialApp(
    title: "Conversor de Moedas",
    home: App(),
    theme: ThemeData(primaryColor: Colors.amber, hintColor: Colors.amber),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Home(),
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar, euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String value) {
    double real = double.parse(value);
    euroController.text = (real / this.euro).toStringAsFixed(2);
    dolarController.text = (real / this.dolar).toStringAsFixed(2);
  }

  void _dolarChanged(String value) {
    double dolar = double.parse(value);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / this.euro).toStringAsFixed(2);
  }

  void _euroChanged(String value) {
    double euro = double.parse(value);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / this.dolar).toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Conversor de Moedas"),
      ),
      body: FutureBuilder<Map>(
        future: _getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center),
              );
              break;
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Ocorreu um erro!",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              } else {

                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                realController.text = "1";
                dolarController.text = (1/dolar).toStringAsFixed(2);
                euroController.text = (1/euro).toStringAsFixed(2);

                return SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      _buildTextField(
                          "Reais", "R\$", realController, _realChanged),
                      Divider(),
                      _buildTextField(
                          "Dólares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      _buildTextField(
                          "Euros", "€", euroController, _euroChanged),
                      Divider(),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> _getData() async {
  http.Response response = await http.get(_REQUEST);
  return json.decode((response.body));
}

TextField _buildTextField(
    String label, String prefix, TextEditingController controller, Function f) {
  return TextField(
    controller: controller,
    onChanged: f,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: "$label ",
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: "$prefix "),
  );
}
