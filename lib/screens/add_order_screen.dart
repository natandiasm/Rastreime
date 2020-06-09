import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/util/correios.dart';
import 'package:scoped_model/scoped_model.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _nameController = TextEditingController();
  final _shippingcodeController = TextEditingController();
  String _categoriaEncomenda;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 22, 98, 187)),
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 30,
              width: 30,
              child: Image.asset(
                'assets/images/title.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _shippingcodeController,
                    decoration: InputDecoration(hintText: "Código"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty) return "Digite um codigo!";
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome"),
                    validator: (text) {
                      if (text.isEmpty) return "Digite o nome do produto";
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  DropDownFormField(
                    titleText: 'Categoria',
                    hintText: 'Escolha uma categoria',
                    value: _categoriaEncomenda,
                    onSaved: (value) {
                      setState(() {
                        _categoriaEncomenda = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _categoriaEncomenda = value;
                      });
                    },
                    dataSource: [
                      {
                        "display": "Eletrônico",
                        "value": "eletronico",
                      },
                      {
                        "display": "Smartphone",
                        "value": "smartphone",
                      },
                      {
                        "display": "Computador",
                        "value": "computador",
                      },
                      {
                        "display": "Eletrodoméstico",
                        "value": "eletrodomestico",
                      },
                      {
                        "display": "Jogo",
                        "value": "jogo",
                      },
                      {
                        "display": "Livro",
                        "value": "livro",
                      },
                      {
                        "display": "Ferramenta",
                        "value": "ferramenta",
                      },
                      {
                        "display": "Esporte",
                        "value": "esporte",
                      },
                      {
                        "display": "Roupa",
                        "value": "roupa",
                      },
                      {
                        "display": "Bolsa",
                        "value": "bolsa",
                      },
                      {
                        "display": "Comida",
                        "value": "comida",
                      },
                      {
                        "display": "Outro",
                        "value": "outro",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        "Adicionar encomenda",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _onPressAddOrderButton(model);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onPressAddOrderButton(model) {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> orderData = {
        "name": _nameController.text,
        "shippingcode": _shippingcodeController.text,
        "category": _categoriaEncomenda,
        "user": model.firebaseUser.uid
      };
      OrderModel.addOrder(
          orderData: orderData,
          onFail: () {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text("Não foi possivel adicionar a encomenda"),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 2),
              ),
            );
          },
          onSucess: () {
            Navigator.of(context).pop();
          });
    }
  }
}
