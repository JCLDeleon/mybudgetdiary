import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mybudgetdiary/features/dashboard/dashboard_service.dart';

import '../../../common/utils.dart';
import '../../../models/wallet.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  Widget incomeBalanceCard(String incomeBalance) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Text(
                    "Income Balance",
                    style: GoogleFonts.montserrat(
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  "PHP $incomeBalance",
                  style: GoogleFonts.roboto(
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              "+2.5%",
              style: GoogleFonts.montserrat(
                fontStyle: FontStyle.normal,
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget monthlyExpenseCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 8,
                  ),
                  child: Text(
                    "Monthly Expense",
                    style: GoogleFonts.montserrat(
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  "PHP 23,000.00",
                  style: GoogleFonts.roboto(
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Text(
              "-0.5%",
              style: GoogleFonts.montserrat(
                fontStyle: FontStyle.normal,
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    num totalFundBalance = 0;

    String fundBalance = '0';
    String incomeBalance = '0';

    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      child: Card(
        margin: const EdgeInsets.all(0),
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
              future: DashboardService.getUserWalletQuery().get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  Wallet? walletInfo;

                  for (var docSnapshot in snapshot.data!.docs) {
                    walletInfo = Wallet.fromMap(docSnapshot);
                    totalFundBalance = walletInfo.wallet_total_savings + walletInfo.wallet_total_income;
                    fundBalance = Utils.returnCurrency(totalFundBalance);
                    incomeBalance = Utils.returnCurrency(walletInfo.wallet_total_income);
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /**
                       * Total Balance
                       **/

                      Column(
                        children: [
                          Text(
                            "Total Balance",
                            style: GoogleFonts.montserrat(
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "PHP $fundBalance",
                            style: GoogleFonts.roboto(
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),

                          /**
                           * Transaction Buttons
                           **/

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Add Income"),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Add Transaction"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.deepPurple,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                            child: Text(
                              "Budget overview",
                              style: GoogleFonts.montserrat(
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          /**
                           * INCOME / EXPENSE Row
                           **/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /**
                               * INCOME
                               **/
                              Expanded(
                                flex: 1,
                                child: incomeBalanceCard(incomeBalance),
                              ),
                              /**
                               * EXPENSE
                               **/
                              Expanded(
                                flex: 1,
                                child: monthlyExpenseCard(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return const Placeholder();
                }
              }),
        ),
      ),
    );
  }
}
