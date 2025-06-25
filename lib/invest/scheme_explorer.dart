// lib/pages/scheme_explorer_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/invest/investment_scheme.dart';
import 'package:sakhi/invest/investment_scheme_detail_page.dart';
import 'package:sakhi/theme/save_theme.dart';

class SchemeExplorerPage extends StatelessWidget {
  SchemeExplorerPage({super.key});

  final List<InvestmentScheme> _allSchemes = [
    InvestmentScheme(
      id: 'ppf',
      name: 'Public Provident Fund (PPF)',
      description:
          'A popular long-term, low-risk government savings scheme with tax benefits.',
      category: 'Government',
      riskLevel: 'Low',
      typicalReturns: '7.1% p.a. (current)',
      minInvestment: '₹500/year',
      lockInPeriod: '15 years',
      taxBenefits: 'EEE (Exempt, Exempt, Exempt) u/s 80C',
      howToStart: 'Open at Post Office or authorized bank branches.',
      icon: FontAwesomeIcons.buildingColumns,
    ),
    InvestmentScheme(
      id: 'ssy',
      name: 'Sukanya Samriddhi Yojana (SSY)',
      description:
          'Exclusive government scheme for the financial future of girl children, offering high returns and tax benefits.',
      category: 'Government',
      riskLevel: 'Low',
      typicalReturns: '8.2% p.a. (current)',
      minInvestment: '₹250/year',
      lockInPeriod: 'Until girl is 21 or married after 18',
      taxBenefits: 'EEE (Exempt, Exempt, Exempt) u/s 80C',
      howToStart:
          'Open at Post Office or authorized bank branches in the name of a girl child below 10 years.',
      icon: Icons.girl_rounded,
    ),
    InvestmentScheme(
      id: 'digital_gold',
      name: 'Digital Gold',
      description:
          'Invest in 24K pure gold digitally, starting with small amounts, without storage worries.',
      category: 'Commodity',
      riskLevel: 'Medium',
      typicalReturns: 'Linked to gold price fluctuations',
      minInvestment: '₹100',
      lockInPeriod: 'None (can sell anytime)',
      taxBenefits: 'Taxable as capital gains',
      howToStart:
          'Buy through various platforms like Google Pay, Paytm, MMTC-PAMP, etc.',
      icon: FontAwesomeIcons.coins,
    ),
    InvestmentScheme(
      id: 'sip_equity',
      name: 'SIP in Equity Mutual Fund',
      description:
          'Systematic Investment Plan in equity funds for long-term wealth creation. Market-linked returns.',
      category: 'Mutual Fund',
      riskLevel: 'High',
      typicalReturns: '12-15%+ p.a. (historical)',
      minInvestment: '₹500/month',
      lockInPeriod: 'No lock-in, but recommended for >5 years',
      taxBenefits: 'Taxable (LTCG/STCG) unless ELSS',
      howToStart:
          'Through a Mutual Fund distributor, bank, or online platforms (e.g., Groww, Zerodha Coin).',
      icon: FontAwesomeIcons.chartLine,
    ),
    InvestmentScheme(
      id: 'lic',
      name: 'Life Insurance Corporation (LIC) Plans',
      description:
          'Insurance-cum-investment plans offering life cover and savings components. Various plan types available.',
      category: 'Insurance-cum-Investment',
      riskLevel: 'Low to Medium',
      typicalReturns: 'Guaranteed or bonus-linked returns (lower than market)',
      minInvestment: 'Varies by plan',
      lockInPeriod: 'Long-term (10-20+ years)',
      taxBenefits: 'Some plans offer 80C benefits',
      howToStart: 'Contact an LIC agent or visit an LIC branch.',
      icon: Icons.shield_rounded,
    ),
    InvestmentScheme(
      id: 'debt_mf',
      name: 'SIP in Debt Mutual Fund',
      description:
          'Invest in debt instruments like bonds and government securities, offering stable returns with lower risk than equity.',
      category: 'Mutual Fund',
      riskLevel: 'Low to Medium',
      typicalReturns: '6-8% p.a.',
      minInvestment: '₹500/month',
      lockInPeriod: 'No lock-in, short-term options available',
      taxBenefits:
          'Taxable as per income slab (short-term) or indexation benefit (long-term)',
      howToStart:
          'Through a Mutual Fund distributor, bank, or online platforms.',
      icon: FontAwesomeIcons.moneyBillWave,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            'Explore Investment Schemes',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Learn about various schemes to make informed decisions:',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ..._allSchemes.map((scheme) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                  child: Icon(
                    scheme.icon,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                title: Text(
                  scheme.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Risk: ${scheme.riskLevel} | Returns: ${scheme.typicalReturns}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: AppTheme.textColor,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InvestmentSchemeDetailPage(scheme: scheme),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Text(
            'Knowledge is power when it comes to investing.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
