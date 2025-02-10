// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:app_lista_de_contatos/models/contatos_model.dart';
import 'package:app_lista_de_contatos/pages/atualizar_page.dart';
import 'package:app_lista_de_contatos/respositories/contatos_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalheContatoPage extends StatefulWidget {
  final ContatosResults contato;

  const DetalheContatoPage({super.key, required this.contato});

  @override
  State<DetalheContatoPage> createState() => _DetalheContatoPageState();
}

class _DetalheContatoPageState extends State<DetalheContatoPage> {
  XFile? photo;
  var contatos = <ContatosResults>[];
  var contatosRepository = ContatosBack4appRepository();

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    carregarDados();
  }

  carregarDados() async {
    var result = await contatosRepository.obterContatos();
    setState(() {
      contatos = result.results ?? [];
    });
  }

  String? formatarData(String data) {
    DateTime dateTime = DateTime.parse(data);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          "Detalhe do contato",
          style: TextStyle(color: Colors.white),
        ),
      ),
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
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${widget.contato.nome}",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            Container(
              width: 200,
              height: 170,
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 120),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3.0),
                  borderRadius: BorderRadius.circular(99)),
              child: ClipOval(
                  child: widget.contato.photopath != null
                      ? Image.file(
                          File(widget.contato.photopath!),
                          width: 200,
                          height: 170,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: FaIcon(FontAwesomeIcons.solidUser),
                        )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    final Uri phoneUri =
                        Uri.parse('tel:${widget.contato.telefone}');
                    if (!await launchUrl(phoneUri)) {
                      throw Exception(
                          "Não foi possivel realizar a chamada para ${widget.contato.telefone}");
                    }
                  },
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.phone,
                      ),
                      Text("Ligar")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var contatoAtualizado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AtualizarContatoPage(contato: widget.contato),
                        ));
                    if (contatoAtualizado != null) {
                      setState(() {
                        widget.contato.nome = contatoAtualizado.nome;
                        widget.contato.telefone = contatoAtualizado.telefone;
                        widget.contato.whatsapp = contatoAtualizado.whatsapp;
                        widget.contato.email = contatoAtualizado.email;
                        widget.contato.endereco = contatoAtualizado.endereco;
                        widget.contato.photopath = contatoAtualizado.photopath;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.pen,
                      ),
                      Text("Editar")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var excluir = await contatosRepository
                        .excluirContato(widget.contato.objectId!);
                    if (excluir) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Contato Excluído",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text("O contato foi removido com sucesso."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Fecha o diálogo
                              },
                              child: Text(
                                "OK",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );

                      // Retorna "true" para indicar que um contato foi excluído
                      Navigator.pop(context, true);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Erro"),
                          content:
                              Text("Ocorreu um erro ao excluir o contato."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.trash,
                      ),
                      Text("Excluir")
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 148, 144, 144),
                    const Color.fromARGB(255, 34, 33, 33)
                  ], // Gradiente de cinza claro para cinza mais escuro
                  begin: Alignment.topLeft, // Início do gradiente
                  end: Alignment.bottomRight, // Fim do gradiente
                ),
                borderRadius:
                    BorderRadius.circular(10), // Opcional: bordas arredondadas
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dados do contato",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("${widget.contato.telefone}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      FaIcon(FontAwesomeIcons.whatsapp,
                          color: Colors.greenAccent),
                      SizedBox(
                        width: 20,
                      ),
                      Text("${widget.contato.whatsapp}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      FaIcon(FontAwesomeIcons.at),
                      SizedBox(
                        width: 20,
                      ),
                      Text("${widget.contato.email}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      FaIcon(FontAwesomeIcons.house, color: Colors.yellow),
                      SizedBox(
                        width: 20,
                      ),
                      Text("${widget.contato.endereco}"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Adicionado em: ${formatarData(widget.contato.createdAt!.substring(0, 10))}"),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
