import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  final bool showAcceptButton;

  const TermsConditionsScreen({
    super.key,
    this.showAcceptButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delicious Food Delivery App',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Terms and Conditions of Use',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSection(
                    context,
                    '1. Acceptance of Terms',
                    'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
                  ),
                  
                  _buildSection(
                    context,
                    '2. Privacy Policy',
                    'Your privacy is important to us. We collect and process personal information in accordance with our Privacy Policy. By using our service, you consent to the collection and use of information as outlined in our Privacy Policy.',
                  ),
                  
                  _buildSection(
                    context,
                    '3. User Account Responsibilities',
                    'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.',
                  ),
                  
                  _buildSection(
                    context,
                    '4. Service Availability',
                    'We strive to provide uninterrupted service, but we do not guarantee that the service will be error-free or uninterrupted. We reserve the right to modify or discontinue the service at any time.',
                  ),
                  
                  _buildSection(
                    context,
                    '5. Educational Project Acknowledgment',
                    'You acknowledge that this is an educational project and agree to provide constructive feedback to help improve the learning experience. As part of your participation in this educational initiative, you agree to send a motivational message or encouragement to the developer at least once during your usage of the application to support their learning journey.',
                  ),
                  
                  _buildSection(
                    context,
                    '6. Order and Payment Terms',
                    'All orders are subject to availability and confirmation. We reserve the right to refuse any order. Payment must be made at the time of ordering through the available payment methods.',
                  ),
                  
                  _buildSection(
                    context,
                    '7. Delivery Terms',
                    'Delivery times are estimates and may vary due to traffic, weather, or other unforeseen circumstances. We are not liable for delays beyond our reasonable control.',
                  ),
                  
                  _buildSection(
                    context,
                    '8. Limitation of Liability',
                    'In no event shall we be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with your use of the service.',
                  ),
                  
                  _buildSection(
                    context,
                    '9. Intellectual Property',
                    'All content, trademarks, and intellectual property rights in the application remain our property or the property of our licensors.',
                  ),
                  
                  _buildSection(
                    context,
                    '10. Modification of Terms',
                    'We reserve the right to modify these terms at any time. Continued use of the service after such modifications constitutes acceptance of the updated terms.',
                  ),
                  
                  _buildSection(
                    context,
                    '11. Contact Information',
                    'If you have any questions about these Terms and Conditions, please contact us through the app\'s support section.',
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Accept button (only shown when needed)
          if (showAcceptButton)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true when accepted
                  },
                  child: const Text(
                    'I Accept Terms & Conditions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
