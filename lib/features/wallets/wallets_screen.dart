import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybudgetdiary/common/utils.dart';
import 'package:mybudgetdiary/features/wallets/wallets_service.dart';
import 'package:mybudgetdiary/models/wallet_item.dart';

enum Categories { savings, income }

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  final balanceController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    balanceController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              balanceController.clear();
              nameController.clear();

              _showWalletInputSheet();
            },
            child: const Text("Add Savings"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            child: FutureBuilder(
              future: WalletService.getUserWalletQuery().get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    SnackBar(content: Text(snapshot.error.toString()));
                  }

                  if (snapshot.hasData) {
                    for (var docSnapshot in snapshot.data!.docs) {
                      return walletListStream(docSnapshot.reference.collection("wallet_items").snapshots());
                    }
                  } else {
                    return const Center(
                      child: Text('No Data found'),
                    );
                  }
                }

                return const Placeholder();
              },
            ),
          )
        ],
      ),
    );
  }

  void _showWalletInputSheet() {
    Categories? categories = Categories.savings;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, void Function(void Function()) setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /**
                   * Title
                   * */
                  Container(
                    margin: const EdgeInsets.only(bottom: 16, top: 16),
                    child: const Center(
                      child: Text(
                        "Input wallet details",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),

                  /**
                   * Wallet Category
                   * */
                  Container(
                    margin: const EdgeInsets.only(bottom: 4, top: 10),
                    child: const Text(
                      "Wallet Category",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: SizedBox(
                          child: ListTile(
                            title: const Text("Savings"),
                            leading: Radio(
                              value: Categories.savings,
                              groupValue: categories,
                              onChanged: (value) {
                                setState(() {
                                  categories = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: SizedBox(
                          child: ListTile(
                            title: const Text("Income"),
                            leading: Radio(
                              value: Categories.income,
                              groupValue: categories,
                              onChanged: (value) {
                                setState(() {
                                  categories = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  /**
                   * Wallet Name
                   * */
                  Container(
                    margin: const EdgeInsets.only(bottom: 4, top: 10),
                    child: const Text(
                      "Wallet Name",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter wallet name",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    controller: nameController,
                  ),

                  /**
                   * Wallet Balance
                   * */
                  Container(
                    margin: const EdgeInsets.only(bottom: 4, top: 10),
                    child: const Text(
                      "Wallet Balance",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter wallet balance",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
                    controller: balanceController,
                  ),

                  /**
                   * Save Button
                   * */
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && balanceController.text.isNotEmpty) {
                        String name = nameController.text;
                        int balance = int.parse(balanceController.text);

                        final walletItem = WalletItem(
                            created_at: DateTime.now().toString(),
                            last_update: DateTime.now().toString(),
                            wallet_item_category: categories == Categories.savings ? 'Savings' : 'Income',
                            wallet_item_name: name,
                            wallet_item_balance: balance);

                        WalletService.addUserWalletItem(walletItem);
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget walletListStream(Stream<QuerySnapshot<Map<String, dynamic>>> queryDocumentSnapshot) {
    return StreamBuilder(
      stream: queryDocumentSnapshot,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            SnackBar(content: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var walletItem = WalletItem.fromMap(snapshot.data!.docs[index]);
                return walletListItem(walletItem);
              },
            );
          } else {
            return const Center(
              child: Text('No Data found'),
            );
          }
        }

        return const Placeholder();
      },
    );
  }

  Widget walletListItem(WalletItem walletItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                walletItem.wallet_item_category,
                style: GoogleFonts.roboto(
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  walletItem.wallet_item_name,
                  style: GoogleFonts.roboto(
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "PHP ${Utils.returnCurrency(walletItem.wallet_item_balance)}",
                  style: GoogleFonts.montserrat(
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
