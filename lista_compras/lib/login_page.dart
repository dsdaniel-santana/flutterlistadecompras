import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
class LoginPage extends StatefulWidget {
  // StatefullWidget significa que a aparencia pode ser alterada
  // a qualquer momento durante a aplicação
  @override
  _LoginPageState createState() => _LoginPageState();
}
 
class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  //Criamos um controle para um input, com um nome especifico
  TextEditingController _passwordController = TextEditingController();
  Future<void> _login(BuildContext context) async {
    final username = _usernameController.text;
    // Criamos uma variavel com o conteúdo do input
    final password = _passwordController.text;
    final response = await http.post(
      // chamamos uma API com os atributos do body (username e password)
      Uri.parse('https://ideawebsites.com.br/api_compras/checasenha.php'),
      body: {
        'username': username,
        'password': password,
      },
    );
 
    if (response.statusCode == 200) {
      // Codigo 200 significa que a consulta foi bem sucedida
      final jsonData = json.decode(response.body);
      final loginStatus = jsonData['loginStatus'];
 
      if (loginStatus != false) {
        Navigator.pushReplacementNamed(context, '/principal');
        // estando tudo certo o app navega para o principal.dart
      } else {
        _showAlertDialog(context, 'Falha na autenticação');
      }
    } else {
      _showAlertDialog(context, 'Erro na requisição: ${response.statusCode}');
    }
  }
 
// paramos aqui
  Future<void> _registerUser(BuildContext context) async {
    // Aqui iniciamos a tela cadastro de novo usuário
    String username = ''; // Zerando as variáveis
    String password = '';
    String name = '';
 
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro de Novo Usuário'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail / Login',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome do Usuário',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Enviar os dados para a API
                final response = await http.post(
                  Uri.parse(
                      'https://ideawebsites.com.br/api_compras/addusuario.php'),
                  body: {
                    'username': username,
                    'password': password,
                    'usuario': name,
                  },
                );
 
                if (response.statusCode == 200) {
                  Navigator.of(context).pop(); // Fechar o dialog
                  _showAlertDialog(context, 'Usuário cadastrado com sucesso!');
                } else {
                  _showAlertDialog(context, 'Erro ao cadastrar usuário');
                }
              },
              child: Text('Cadastrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o dialog
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
 
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras - Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuário',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Entrar'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _registerUser(context),
              child: Text('Cadastrar Novo Usuário'),
            ),
          ],
        ),
      ),
    );
  }
}
 
 