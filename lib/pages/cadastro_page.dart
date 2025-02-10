import 'dart:io';
import 'package:app_lista_de_contatos/models/contatos_model.dart';
import 'package:app_lista_de_contatos/pages/main_page.dart';
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

class CadastroContatosPage extends StatefulWidget {
  const CadastroContatosPage({super.key});

  @override
  State<CadastroContatosPage> createState() => _CadastroContatosPageState();
}

class _CadastroContatosPageState extends State<CadastroContatosPage> {
  XFile? photo;
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  var contatosRepository = ContatosBack4appRepository();

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
      Uint8List imageBytes = await croppedFile.readAsBytes();
      // ignore: unused_local_variable
      final result = await ImageGallerySaver.saveImage(imageBytes);
      setState(() {
        photo = XFile(croppedFile.path);
      });

      photo = XFile(croppedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              Text(
                "cadastro de contatos",
                style: TextStyle(fontSize: 17),
              ),
              Container(
                  width: 200,
                  height: 170,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 120),
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
                                              // ignore: use_build_context_synchronously
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.black,
                                                title: Text(
                                                  "Salvo!",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Text(
                                                    "A imagem foi salva com sucesso!"),
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
                                              // ignore: use_build_context_synchronously
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: Colors.black,
                                                title: Text(
                                                  "Erro!",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Text(
                                                    "Não foi possivel salvar a imagem!"),
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
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "Adicionar foto",
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
                      icon: FontAwesomeIcons.addressCard,
                      iconColor: Colors.black,
                      controller: nomeController,
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustom(
                      label: "Telefone",
                      icon: FontAwesomeIcons.phone,
                      iconColor: Colors.blue,
                      controller: telefoneController,
                      tipoInput: TextInputType.phone,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter(),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormFieldCustom(
                        label: "WhatsApp",
                        icon: FontAwesomeIcons.whatsapp,
                        iconColor: Colors.greenAccent,
                        controller: whatsAppController,
                        tipoInput: TextInputType.phone,
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
                    String? fotoPath = photo?.path;

                    ContatosResults novoContato = ContatosResults(
                        nome: nome,
                        telefone: telefone,
                        whatsapp: whatsApp,
                        email: email,
                        endereco: endereco,
                        photopath: fotoPath);

                    bool concluido =
                        await contatosRepository.cadastrarContato(novoContato);
                    if (concluido) {
                      await showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Salvo!",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text("Contato cadastrado com sucesso"),
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
                      Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPage(),
                          ));
                    } else {
                      await showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Erro!",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text("Não foi possivel cadastrar o contato"),
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
                    "Cadastrar",
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
