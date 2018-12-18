import "package:flutter/material.dart";

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IMC Calculator",
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados!";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    _setInfoText("Informe seus dados!");
  }

  void _calculate() {
    double weigth = double.parse(weightController.text);
    double height = double.parse(heightController.text);

    double imc = weigth / (height * height);
    String text;

    if (imc < 18.6)
      text = "Abaixo do peso (${imc.toStringAsPrecision(3)})";
    else if (imc >= 18.6 && imc <= 25)
      text = "Peso Ideal (${imc.toStringAsPrecision(3)})";
    else if (imc > 25 && imc <= 30)
      text = "Levemente Acima do Peso (${imc.toStringAsPrecision(3)})";
    else if (imc > 30 && imc <= 35)
      text = "Obesidade Grau I (${imc.toStringAsPrecision(3)})";
    else if (imc > 35 && imc <= 40)
      text = "Obesidade Grau II (${imc.toStringAsPrecision(3)})";
    else
      text = "Obesidade Grau III (${imc.toStringAsPrecision(3)})";

    _setInfoText(text);
  }

  void _setInfoText(String text) {
    setState(() {
      _infoText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de IMC"),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.person,
                        size: 120.0, color: Colors.teal),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Peso (kg)",
                          labelStyle:
                              TextStyle(color: Colors.teal)),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.teal, fontSize: 25.0),
                      controller: weightController,
                      validator: (value){
                        if(value.isEmpty){
                          return "Insira seu peso";
                        }
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Altura (m)",
                          labelStyle:
                              TextStyle(color: Colors.teal)),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.teal, fontSize: 25.0),
                      controller: heightController,
                      validator: (value){
                        if(value.isEmpty){
                          return "Insira sua altura";
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Container(
                          height: 50.0,
                          child: RaisedButton(
                            onPressed: (){
                              if(_formKey.currentState.validate())
                                _calculate();
                              },
                            child: Text(
                              "Calcular",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                            ),
                            color: Colors.teal,
                          )),
                    ),
                    Text("$_infoText",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.teal, fontSize: 25.0))
                  ],
                ))));
  }
}
