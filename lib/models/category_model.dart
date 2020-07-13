import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CategoryModel {
  static List getAllCategory() {
    return [
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
    ];
  }

  static List getIconNameAllCategory() {
    return [
      ["eletronico", LineAwesomeIcons.headphones],
      ["smartphone", LineAwesomeIcons.mobile_phone],
      ["computador", LineAwesomeIcons.laptop],
      ["jogo", LineAwesomeIcons.gamepad],
      ["eletrodomestico", LineAwesomeIcons.tv],
      ["livro", LineAwesomeIcons.book],
      ["ferramenta", LineAwesomeIcons.wrench],
      ["esporte", LineAwesomeIcons.futbol_o],
      ["roupa", LineAwesomeIcons.female],
      ["bolsa", LineAwesomeIcons.briefcase],
      ["comida", LineAwesomeIcons.coffee],
      ["outros", LineAwesomeIcons.plus]
    ];
  }

  static getIconById({@required String name}) {
    switch (name) {
      case "eletronico":
        return LineAwesomeIcons.headphones;
        break;
      case "smartphone":
        return LineAwesomeIcons.mobile_phone;
        break;
      case "computador":
        return LineAwesomeIcons.laptop;
        break;
      case "jogo":
        return LineAwesomeIcons.gamepad;
        break;
      case "eletrodomestico":
        return LineAwesomeIcons.tv;
        break;
      case "livro":
        return LineAwesomeIcons.book;
        break;
      case "ferramenta":
        return LineAwesomeIcons.wrench;
        break;
      case "esporte":
        return LineAwesomeIcons.futbol_o;
        break;
      case "roupa":
        return LineAwesomeIcons.female;
        break;
      case "bolsa":
        return LineAwesomeIcons.briefcase;
        break;
      case "comida":
        return LineAwesomeIcons.coffee;
        break;
      default:
        return LineAwesomeIcons.plus;
        break;
    }
  }
}
