import 'dart:io';

import 'package:app_lista_de_contatos/models/contatos_model.dart';
import 'package:app_lista_de_contatos/pages/detalhes_contato_page.dart';
import 'package:app_lista_de_contatos/respositories/contatos_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListaContatoPage extends StatefulWidget {
  const ListaContatoPage({
    super.key,
  });

  @override
  State<ListaContatoPage> createState() => _ListaContatoPageState();
}

class _ListaContatoPageState extends State<ListaContatoPage> {
  var contatosRepository = ContatosBack4appRepository();
  var contatosModel = ContatosModel();
  var contatos = <ContatosResults>[];
  List<ContatosResults> contatosFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    carregarDados();
    super.initState();
  }

  carregarDados() async {
    var result = await contatosRepository.obterContatos();
    setState(() {
      contatos = result.results ?? [];
      contatosFiltrados = contatos;
      contatos.sort(
          (a, b) => a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase()));
    });
  }

  filtrarContatos(String input) {
    setState(() {
      if (input.isEmpty) {
        contatosFiltrados = contatos;
      } else {
        contatosFiltrados = contatos
            .where((contato) =>
                contato.nome!.toLowerCase().contains(input.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 82, 67, 67),
              const Color.fromARGB(255, 34, 33, 33)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Text(
              "lista de contatos",
              style: TextStyle(fontSize: 17),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Pesquisar contato...",
                  border: InputBorder.none,
                  prefix: FaIcon(FontAwesomeIcons.magnifyingGlass),
                ),
                onChanged: filtrarContatos,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: contatosFiltrados.length,
                itemBuilder: (context, index) {
                  var contato = contatosFiltrados[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 148, 144, 144),
                              const Color.fromARGB(255, 34, 33, 33)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      var resultado = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetalheContatoPage(
                                                      contato: contato)));
                                      if (resultado != null) {
                                        carregarDados();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 50,
                                            height: 50,
                                            //margin: EdgeInsets.symmetric(vertical: 30, horizontal: 120),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1.5),
                                            ),
                                            child: ClipOval(
                                                child: contato.photopath !=
                                                            null &&
                                                        contato.photopath!
                                                            .isNotEmpty
                                                    ? Image.file(
                                                        File(
                                                            contato.photopath!),
                                                        width: 30,
                                                        height: 30,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Center(
                                                        child: FaIcon(
                                                            FontAwesomeIcons
                                                                .solidUser),
                                                      ))),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${contato.nome}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
