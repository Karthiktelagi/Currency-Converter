import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double exchangeRate = 1.0;
  TextEditingController amountController = TextEditingController();
  double convertedAmount = 0.0;

  Future<void> fetchExchangeRate() async {
    final url =
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        exchangeRate = data['rates'][toCurrency];
      });
    } else {
      throw Exception('Failed to load exchange rate in the page');
    }
  }

  void convertCurrency() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    setState(() {
      convertedAmount = amount * exchangeRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar:  AppBar(title: const Text('Currency Converter' ,),
      backgroundColor: Colors.blue,),
      body: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter amount'),
            ),
            DropdownButton<String>(
              value: fromCurrency,
              items: ['USD', 'EUR', 'GBP', 'INR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  fromCurrency = newValue!;
                });
                fetchExchangeRate();
              },
            ),
            DropdownButton<String>(
              value: toCurrency,
              items: ['USD', 'EUR', 'GBP', 'INR'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  toCurrency = newValue!;
                });
                fetchExchangeRate();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: convertCurrency,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            Text('Converted Amount: \$${convertedAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
