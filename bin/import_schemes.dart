import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yojna_mitr/firebase_options.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  // Dummy schemes
  final schemes = [
    {
      'name': 'PM-Kisan Samman Nidhi',
      'description': 'Income support for farmers offering ₹6000/year in 3 installments.',
      'eligibility': ['Farmer', 'Small Landholding'],
      'state': 'All',
      'sector': 'Agriculture',
      'applyLink': 'https://pmkisan.gov.in',
    },
    {
      'name': 'Beti Bachao Beti Padhao',
      'description': 'Welfare program for girl child education and empowerment.',
      'eligibility': ['Girl Child', 'Parents', 'Women'],
      'state': 'All',
      'sector': 'Women & Child Development',
      'applyLink': 'https://wcd.nic.in/bbbp-scheme',
    },
    {
      'name': 'National Scholarship Portal',
      'description': 'Scholarships for minority and low-income students.',
      'eligibility': ['Student', 'Minority', 'Low Income'],
      'state': 'All',
      'sector': 'Education',
      'applyLink': 'https://scholarships.gov.in',
    },
    {
      'name': 'PM Mudra Yojana',
      'description': 'Collateral-free loans for small business owners and startups.',
      'eligibility': ['Entrepreneur', 'Business Owner', 'MSME'],
      'state': 'All',
      'sector': 'MSME & Finance',
      'applyLink': 'https://www.mudra.org.in',
    },
  ];

  for (var scheme in schemes) {
    await firestore.collection('schemes').add(scheme);
    print("Added: ${scheme['name']}");
  }

  print("✅ All dummy schemes imported.");
}
