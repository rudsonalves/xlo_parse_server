// Copyright (C) 2024 Rudson Alves
//
// This file is part of xlo_parse_server.
//
// xlo_parse_server is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// xlo_parse_server is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xlo_parse_server.  If not, see <https://www.gnu.org/licenses/>.

class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-mail é obrigatório!';
    }
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) {
      return 'Entre um e-mail válido!';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password é obrigatório!';
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$');
    if (!regex.hasMatch(value)) {
      return 'Senha deve ser 6+ caracteres com letras e números!';
    }
    return null;
  }

  static String? checkPassword(String? password, String? value) {
    if (value == null || value.isEmpty) {
      return 'Password é obrigatório!';
    }
    if (password != value) {
      return 'As senhas são diferentes!';
    }
    return null;
  }

  static String? nickname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Apelido é obrigatório!';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Apelido é obrigatório!';
    }
    return null;
  }

  // Sales Validators
  static String? title(String? value) {
    if (value == null || value.length < 3) {
      return 'Título é obrigatório e deve ser maior que 3 caracteres';
    }
    return null;
  }

  static String? description(String? value) {
    if (value == null) {
      return 'Descrição é obrigatório.';
    } else if (value.length < 20) {
      return 'Ao menos 20 caracteres. Detalhe o estado do produto.';
    }
    return null;
  }

  static String? mechanics(String? value) {
    if (value == null || value.isEmpty) {
      return 'Selecione alguma mecânica.';
    }
    return null;
  }

  static String? address(String? value) {
    if (value == null) {
      return 'Endereço é obrigatório';
    }
    if (value.isEmpty || value.length < 8) {
      return 'Endereço inválido';
    }
    return null;
  }

  static String? zipCode(String? value) {
    if (value == null) {
      return 'CEP é obrigatório';
    } else if (value.length < 8) {
      return 'CEP inválido';
    }
    return null;
  }

  static String? cust(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preço é obrigatório';
    }
    return null;
  }
}
