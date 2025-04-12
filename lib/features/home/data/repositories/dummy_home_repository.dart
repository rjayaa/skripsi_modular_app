// lib/features/home/data/repositories/dummy_home_repository.dart
import 'package:modular_skripsi_app/features/home/data/models/news_model.dart';
import 'package:modular_skripsi_app/features/home/data/models/promotion_model.dart';

class DummyHomeRepository {
  // Get promotions
  Future<List<PromotionModel>> getPromotions() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      PromotionModel(
        id: '1',
        title: 'Bundle 50 Mbps + TV',
        description:
            'Get high-speed internet with 50 Mbps and premium TV channels in one package.',
        imageUrl: 'assets/images/promotions/50mbps.jpg',
        price: 450000,
        discountPrice: 399000,
        validUntil: DateTime.now().add(const Duration(days: 30)),
      ),
      PromotionModel(
        id: '2',
        title: 'Gaming Package 100 Mbps',
        description:
            'Ultimate gaming experience with low latency and 100 Mbps download speed.',
        imageUrl: 'assets/images/promotions/100mbps.jpg',
        price: 650000,
        discountPrice: 599000,
        validUntil: DateTime.now().add(const Duration(days: 15)),
      ),
      PromotionModel(
        id: '3',
        title: 'Work From Home 25 Mbps',
        description:
            'Reliable connection for your home office needs with 25 Mbps speed.',
        imageUrl: 'assets/images/promotions/25mbps.jpg',
        price: 299000,
        validUntil: DateTime.now().add(const Duration(days: 45)),
      ),
    ];
  }

  // Add this method to lib/features/home/data/repositories/dummy_home_repository.dart
  Future<List<NewsModel>> getNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      NewsModel(
        id: '1',
        title: 'Planned Maintenance on March 15',
        summary:
            'Important information about upcoming network maintenance that may affect your service.',
        content:
            'We will be performing scheduled maintenance on our network infrastructure on March 15, 2025, from 2:00 AM to 5:00 AM. During this time, you may experience brief interruptions in your internet service as we upgrade our equipment to enhance overall network performance and reliability.\n\nThe maintenance activities include firmware updates to our core routers, capacity expansion on our main distribution nodes, and optimization of traffic routing to reduce latency.\n\nWe apologize for any inconvenience this may cause and appreciate your understanding as we work to improve your internet experience. If you have any questions or concerns, please contact our customer support team.',
        imageUrl: 'assets/images/news/maintenance.jpg',
        publishDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NewsModel(
        id: '2',
        title: 'New Speed Tiers Available in Your Area',
        summary:
            'We\'ve upgraded our network infrastructure to support higher speeds in selected areas.',
        content:
            'We\'re excited to announce that we have completed a major network upgrade in your area, allowing us to offer new high-speed internet tiers with download speeds of up to 500 Mbps!\n\nThese new plans are perfect for households with multiple users streaming 4K content, gaming online, and working from home simultaneously. Our enhanced infrastructure ensures lower latency and more consistent speeds even during peak usage hours.\n\nContact our customer service team to learn more about upgrading your current plan to one of our new high-speed options. Special promotional pricing is available for existing customers who upgrade within the next 30 days.',
        imageUrl: 'assets/images/news/new-speed.jpg',
        publishDate: DateTime.now().subtract(const Duration(days: 7)),
        category: 'Network Updates',
      ),
      NewsModel(
        id: '3',
        title: 'Customer Support Hours Extended',
        summary:
            'Our support team is now available 24/7 to better assist you with any technical issues.',
        content:
            'We\'re pleased to announce that our customer support team will now be available 24 hours a day, 7 days a week, to provide you with assistance whenever you need it.\n\nThis change comes in response to feedback from our valued customers who have requested more flexible support hours. Whether you\'re experiencing technical difficulties in the middle of the night or have questions about your service on the weekend, our dedicated support specialists will be ready to help.\n\nYou can reach our support team through multiple channels:\n\n- Phone: Our main support line at (021) 555-0123\n- Live Chat: Available through our website and mobile app\n- Email: support@ispprovider.com\n\nWe remain committed to providing you with the best possible service and support experience.',
        imageUrl: 'assets/images/news/customer-support.jpg',
        publishDate: DateTime.now().subtract(const Duration(days: 14)),
        category: 'Customer Service',
      ),
    ];
  }
}
