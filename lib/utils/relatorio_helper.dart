import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../model/item.dart'; // Certifique-se de que o caminho do import está correto

class RelatorioHelper {
  static Future<void> generateReport(List<Item> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Lista de Compras", style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return pw.Text('${item.nome} - Quantidade: ${item.quantidade}');
                },
              ),
            ],
          );
        },
      ),
    );

    // Abre o documento PDF para impressão ou compartilhamento
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
