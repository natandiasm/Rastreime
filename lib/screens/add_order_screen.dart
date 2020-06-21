import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:rastreimy/models/category_model.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/widgets/custom_button.dart';
import 'package:rastreimy/widgets/custom_input.dart';
import 'package:scoped_model/scoped_model.dart';

class AddOrderScreen extends StatefulWidget {
  final DocumentSnapshot order;

  AddOrderScreen({this.order});

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
    if (widget.order != null) {
      setState(() {
        _nameController.text = widget.order["name"];
        _shippingcodeController.text = widget.order["shippingcode"];
        _categoriaEncomenda = widget.order["category"];
      });
    }
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
                  Container(
                      height: 200,
                      child: Image.asset('assets/images/order.png')),
                  CustomInput(
                    controller: _shippingcodeController,
                    hintText: "Código",
                    keyboardType: TextInputType.text,
                    enabled: widget.order == null ? true : false,
                    maxLength: 13,
                    validator: (text) {
                      if (text.length < 13)
                        return "Codigo de rastreio invalido.";
                      if (text.isEmpty) return "Digite um codigo.";
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomInput(
                      controller: _nameController,
                      hintText: "Nome",
                      validator: (text) {
                        if (text.isEmpty) return "Digite o nome da encomenda.";
                      },
                    ),
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
                    validator: (text) {
                      if (text.isEmpty) return "Digite o nome da encomenda.";
                    },
                    dataSource: CategoryModel.getAllCategory(),
                    textField: 'display',
                    valueField: 'value',
                  ),
                  CustomButton(
                    child: Text(
                      widget.order == null
                          ? "Adicionar encomenda"
                          : "Salvar alteração",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _onPressAddOrderButton(model);
                    },
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
        "user": model.firebaseUser.uid,
        "delivered": false,
        "events": 0,
      };
      if (widget.order != null) {
        OrderModel.updateOrder(
            order: widget.order,
            orderData: orderData,
            onFail: () {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text("Não foi possivel atualizar sua encomenda."),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            onSucess: () {
              Navigator.of(context).pop();
            });
      } else {
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
}
