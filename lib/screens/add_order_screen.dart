import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/category_model.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/util/correios.dart';
import 'package:rastreimy/util/upperCaseTextFormatter.dart';
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
  bool _errorCategory = false;
  List _catEnco;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _tapAddButton = false;

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      super.setState(() {
        _nameController.text = widget.order["name"];
        _shippingcodeController.text = widget.order["shippingcode"];
        _catEnco = [
          widget.order["category"],
          CategoryModel.getIconById(name: widget.order["category"])
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 40.0,
    ));
    return Scaffold(
        key: _scaffoldKey,
        persistentFooterButtons: fakeBottomButtons,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Get.theme.primaryColor),
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 30,
              width: 30,
              child: Get.isDarkMode
                  ? Image.asset(
                      'assets/images/title-dark.png',
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/images/title.png',
                      fit: BoxFit.contain,
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
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              height: 200,
                              child: Get.isDarkMode
                                  ? Image.asset(
                                      'assets/images/order-dark.png',
                                    )
                                  : Image.asset(
                                      'assets/images/order.png',
                                    )),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      spreadRadius: 0,
                                      offset: Offset(0, 2))
                                ],
                                border: !_errorCategory
                                    ? Border.all(
                                        width: 0, color: Get.theme.cardColor)
                                    : Border.all(width: 2, color: Colors.red),
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                              color: Get.theme.cardColor,
                              icon: _catEnco == null
                                  ? Icon(LineAwesomeIcons.tag,
                                      color: Get.textTheme.bodyText1.color)
                                  : Icon(_catEnco[1],
                                      color: Get.textTheme.bodyText1.color),
                              onPressed: _onPressSelectCategoryButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CustomInput(
                      controller: _shippingcodeController,
                      hintText: "Código",
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.text,
                      enabled: widget.order == null ? true : false,
                      maxLength: 13,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                      ],
                      validator: (text) {
                        if (!Correios().isValidOrderCode(text))
                          return "Codigo de rastreio invalido";
                        if (text.length < 13)
                          return "Código de rastreio incompleto.";
                        if (text.isEmpty) return "Digite um código.";
                      },
                    ),
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
                  CustomButton(
                    child: !_tapAddButton
                        ? Text(
                            widget.order == null
                                ? "Adicionar encomenda"
                                : "Salvar alteração",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()),
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

  void _onPressSelectCategoryButton() {
    List category = CategoryModel.getIconNameAllCategory();
    Get.defaultDialog(
      title: "Selecione a categoria",
      content: Column(
        children: <Widget>[
          Text(
            "Arraste para exibir mais categorias",
            style: TextStyle(color: Get.theme.primaryColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              height: 300,
              width: Get.width,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(category.length, (index) {
                  return FlatButton(
                    onPressed: () {
                      _onPressCategoryButton(category[index][0]);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          category[index][1],
                          size: 40,
                        ),
                        Text(category[index][0])
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressCategoryButton(String name) {
    setState(() {
      _catEnco = [name, CategoryModel.getIconById(name: name)];
    });
    Get.back();
  }

  void _onPressAddOrderButton(model) {
    if (_formKey.currentState.validate()) {
      if (_catEnco != null) {
        if (!_tapAddButton) {
          setState(() {
            _tapAddButton = true;
            _errorCategory = false;
          });
          if (widget.order == null) {
            Correios()
                .rastrear(codigo: _shippingcodeController.text)
                .then((correiosData) {
              List<dynamic> tranckingEvents = correiosData["quantidade"] == 0
                  ? []
                  : correiosData["eventos"];
              Map<String, dynamic> orderData = {
                "name": _nameController.text,
                "shippingcode": _shippingcodeController.text,
                "category": _catEnco[0],
                "carrier": "correios",
                "user": model.firebaseUser.uid,
                "delivered": false,
                "events": correiosData["quantidade"],
                "tranckingEvents": tranckingEvents,
                "createDate": DateTime.now()
              };
              OrderModel.addOrder(
                  orderData: orderData,
                  onFail: () {
                    setState(() {
                      _tapAddButton = false;
                    });
                    Get.snackbar(
                        "Erro", "Não foi possivel adicionar a sua encomenda.");
                  },
                  onSucess: () {
                    Get.back();
                  });
            });
          } else {
            Map<String, dynamic> orderData = {
              "name": _nameController.text,
              "category": _catEnco[0],
            };
            OrderModel.updateOrder(
                order: widget.order,
                orderData: orderData,
                onFail: () {
                  setState(() {
                    _tapAddButton = false;
                  });
                  Get.snackbar(
                      "Erro", "Não foi possivel atualizar sua encomenda.");
                },
                onSucess: () {
                  Get.back();
                });
          }
        }
      } else {
        setState(() {
          _errorCategory = true;
        });
      }
    }
  }
}
