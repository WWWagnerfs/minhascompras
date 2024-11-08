import 'package:flutter/material.dart';
import 'package:minhascompras/utils/relatorio_helper.dart';
import 'package:rive/rive.dart';
import 'db/database_helper.dart';
import 'model/item.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DatabaseHelper.instance.fetchItems();
    setState(() {
      _items = items;
    });
  }

  Future<void> _addItem() async {
    final nome = _nomeController.text;
    final quantidade = int.tryParse(_quantidadeController.text) ?? 1;
    final item = Item(nome: nome, quantidade: quantidade);

    await DatabaseHelper.instance.insertItem(item);
    _loadItems();

    _nomeController.clear();
    _quantidadeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Lista de Compras", style: TextStyle(color: Colors.white)),
      ),
      body: Column(

        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome do Item'),
          ),
          TextField(
            controller: _quantidadeController,
            decoration: InputDecoration(labelText: 'Quantidade'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(onPressed: _addItem, child: Text("Adicionar")),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.nome),
                  subtitle: Text('Quantidade: ${item.quantidade}'),
                );
              },
            ),
          ),
          SizedBox(
            height: 200, // Tamanho ajustado para a animação
            child: RiveAnimation.asset(
              'assets/animations/delivery_icon_demo.riv',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          RelatorioHelper.generateReport(_items); // Gera o relatório com a lista de itens
        },
        child: Icon(Icons.picture_as_pdf),
        tooltip: 'Gerar Relatório',
      ),
    );
  }
}
