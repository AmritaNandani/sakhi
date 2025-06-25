// lib/models/investment_scheme.dart

import 'package:flutter/material.dart'; // For IconData, etc.

class InvestmentScheme {
  final String id;
  final String name;
  final String description;
  final String category; // e.g., 'Government', 'Mutual Fund', 'Gold'
  final String riskLevel; // e.g., 'Low', 'Medium', 'High'
  final String typicalReturns; // e.g., '7-8% p.a.', 'Market Linked'
  final String minInvestment; // e.g., '₹100', '₹500'
  final String lockInPeriod; // e.g., '5 years', '15 years'
  final String taxBenefits; // e.g., '80C', 'Taxable'
  final String howToStart;
  final IconData icon;

  InvestmentScheme({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.riskLevel,
    required this.typicalReturns,
    required this.minInvestment,
    required this.lockInPeriod,
    required this.taxBenefits,
    required this.howToStart,
    required this.icon,
  });
}
