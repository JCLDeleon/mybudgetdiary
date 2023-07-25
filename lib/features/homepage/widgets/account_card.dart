import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybudgetdiary/features/homepage/homepage_service.dart';

import '../../../common/utils.dart';
import '../models/savings.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showBottomModal(BuildContext context) async {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return FutureBuilder(
                  future: HomepageService.getUserSavings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none) {
                      return Container();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        Savings? savings = snapshot.data?[index];
                        String? name = savings?.savingsName ?? "";
                        String balance = Utils.returnPHCurrency(savings?.balance ?? 0);

                        return InkWell(
                          onTap: () {
                            setState(
                              () {
                                selectedIndex = index;
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.black26, width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.roboto(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Divider(),
                                Text(
                                  "PHP $balance",
                                  style: GoogleFonts.roboto(
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        },
      );
    }

    return Column(
      children: [
        FutureBuilder(
          future: HomepageService.getUserSavings(),
          builder: (context, snapshot) {
            Savings? savings = snapshot.data?[selectedIndex];
            String? name = savings?.savingsName ?? "";
            String balance = Utils.returnPHCurrency(savings?.balance ?? 0);

            if (snapshot.connectionState == ConnectionState.none) {
              return Container();
            }
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.black26, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      showBottomModal(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.montserrat(
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "PHP $balance",
                    style: GoogleFonts.roboto(
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
