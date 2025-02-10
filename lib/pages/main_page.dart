import 'package:app_lista_de_contatos/pages/cadastro_page.dart';
import 'package:app_lista_de_contatos/pages/lista_contato_page.dart';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: TabBarView(
              controller: tabController,
              children: [
                ListaContatoPage(),
                CadastroContatosPage(),
              ],
            ),
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: Colors.black,
              color: Colors.white,
              items: [
                TabItem(icon: Icons.list, title: 'Contatos'),
                TabItem(icon: Icons.person_add_alt_1, title: 'Cadastro'),
              ],
              onTap: (int i) => tabController.index = i,
              controller: tabController,
            )));
  }
}
