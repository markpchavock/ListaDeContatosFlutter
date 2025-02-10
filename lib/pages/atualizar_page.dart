// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:app_lista_de_contatos/models/contatos_model.dart';
import 'package:app_lista_de_contatos/respositories/contatos_back4app_repository.dart';
import 'package:app_lista_de_contatos/share/widgets/text_form_field_custom.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class AtualizarContatoPage extends StatefulWidget {
  final ContatosResults contato;
  const AtualizarContatoPage({super.key, required this.contato});

  @override
  State<AtualizarContatoPage> createState() => _AtualizarContatoPageState();
}

class _AtualizarContatoPageState extends State<AtualizarContatoPage> {
  XFile? photo;
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  var contatosRepository = ContatosBack4appRepository();

  @override
  initState() {
    super.initState();
    setState(() {
      carregarDados();
    });
  }

  carregarDados() async {
    nomeController.text = widget.contato.nome ?? "";
    telefoneController.text = widget.contato.telefone ?? "";
    whatsAppController.text = widget.contato.whatsapp ?? "";
    emailController.text = widget.contato.email ?? "";
    enderecoController.text = widget.contato.endereco ?? "";

    if (widget.contato.photopath != null) {
      photo = XFile(widget.contato.photopath!);
    }
  }

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File croppedImageFile = File(croppedFile.path);
      await croppedImageFile.copy(imageFile.path);
      setState(() {
        photo = XFile(croppedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          "Atualizar informações",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 82, 67, 67),
                const Color.fromARGB(255, 34, 33, 33)
              ], // Gradiente de cinza claro para cinza mais escuro
              begin: Alignment.topLeft, // Início do gradiente
              end: Alignment.bottomRight, // Fim do gradiente
            ),
            // borderRadius:
            //     BorderRadius.circular(10), // Opcional: bordas arredondadas
          ),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 170,
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 120),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.0),
                  ),
                  child: ClipOval(
                      child: photo != null
                          ? Image.file(
                              File(photo!.path),
                              width: 200,
                              height: 170,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: FaIcon(FontAwesomeIcons.solidUser),
                            ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.camera,
                      ),
                      TextButton(
                          onPressed: () async {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: FaIcon(FontAwesomeIcons.camera),
                                      title: Text("Camera"),
                                      onTap: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        photo = await picker.pickImage(
                                            source: ImageSource.camera);
                                        if (photo != null) {
                                          // ignore: unused_local_variable
                                          String path = (await path_provider
                                                  .getApplicationDocumentsDirectory())
                                              .path;
                                          final File imageFile =
                                              File(photo!.path);
                                          final Uint8List imageBytes =
                                              await imageFile.readAsBytes();
                                          final result =
                                              await ImageGallerySaver.saveImage(
                                                  imageBytes);
                                          if ((result['isSucess'] as bool?) ??
                                              false) {
                                            await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.black,
                                                title: Text(
                                                  "Salvo!",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Text(
                                                    "A imagem foi atualizada com sucesso!"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Fecha o diálogo
                                                    },
                                                    child: Text(
                                                      "OK",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.black,
                                                title: Text(
                                                  "Erro!",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Text(
                                                    "Não foi possivel atualizar a imagem!"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Fecha o diálogo
                                                    },
                                                    child: Text(
                                                      "OK",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          setState(() {});
                                          if (photo != null) {
                                            cropImage(photo!);
                                          }
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                    ListTile(
                                      leading: FaIcon(FontAwesomeIcons.image),
                                      title: Text("Galeria"),
                                      onTap: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        photo = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() {});

                                        if (photo != null) {
                                          cropImage(photo!);
                                        }
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Alterar foto",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5,
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
                  borderRadius: BorderRadius.circular(
                      10), // Opcional: bordas arredondadas
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormFieldCustom(
                      label: "Nome",
                      icon: FontAwesomeIcons.person,
                      iconColor: Colors.black,
                      controller: nomeController,
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustom(
                      label: "Telefone",
                      icon: FontAwesomeIcons.phone,
                      iconColor: Colors.blue,
                      controller: telefoneController,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter()
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustom(
                        label: "WhatsApp",
                        icon: FontAwesomeIcons.whatsapp,
                        iconColor: Colors.greenAccent,
                        controller: whatsAppController,
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter()
                        ]),
                    SizedBox(height: 20),
                    TextFormFieldCustom(
                        label: "Email",
                        icon: FontAwesomeIcons.at,
                        iconColor: const Color.fromARGB(255, 58, 58, 58),
                        controller: emailController),
                    SizedBox(height: 20),
                    TextFormFieldCustom(
                        label: "Endereço",
                        icon: FontAwesomeIcons.house,
                        iconColor: Colors.yellow,
                        controller: enderecoController),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 148, 144, 144),
                      const Color.fromARGB(255, 34, 33, 33),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    String nome = nomeController.text;
                    String telefone = telefoneController.text;
                    String whatsApp = whatsAppController.text;
                    String email = emailController.text;
                    String endereco = enderecoController.text;
                    String? fotoPath = photo?.path ?? widget.contato.photopath;

                    ContatosResults contatoAtualizado = ContatosResults(
                        objectId: widget.contato.objectId,
                        nome: nome,
                        telefone: telefone,
                        whatsapp: whatsApp,
                        email: email,
                        endereco: endereco,
                        photopath: fotoPath);

                    bool concluido = await contatosRepository
                        .atualizarCadastro(contatoAtualizado);
                    setState(() {});
                    if (concluido) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Contato Atualizado!",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                              "As informações foram atualizadas com sucesso."),
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
                      Navigator.pop(context, contatoAtualizado);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
