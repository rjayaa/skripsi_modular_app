// lib/features/home/presentation/widgets/promotions_carousel.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/promotion_model.dart';
import '../../data/repositories/dummy_home_repository.dart';
import '../pages/promotion_detail_page.dart';

class PromotionsCarousel extends StatefulWidget {
  final DummyHomeRepository repository;

  const PromotionsCarousel({Key? key, required this.repository})
    : super(key: key);

  @override
  State<PromotionsCarousel> createState() => _PromotionsCarouselState();
}

class _PromotionsCarouselState extends State<PromotionsCarousel> {
  late Future<List<PromotionModel>> _promotionsFuture;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _promotionsFuture = widget.repository.getPromotions();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PromotionModel>>(
      future: _promotionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorView(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyView();
        }

        final promotions = snapshot.data!;
        return Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                itemCount: promotions.length,
                itemBuilder: (context, index) {
                  final promotion = promotions[index];
                  // Apply scale effect to items
                  double scale = _currentPage == index ? 1.0 : 0.9;
                  return TweenAnimationBuilder(
                    tween: Tween(begin: scale, end: scale),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutQuint,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale as double,
                        child: child,
                      );
                    },
                    child: _buildPromotionCard(context, promotion),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                promotions.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPromotionCard(BuildContext context, PromotionModel promotion) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromotionDetailPage(promotion: promotion),
            ),
          );
        },
        child: Card(
          elevation: 6,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image with error handling
                  Image(
                    image:
                        promotion.imageUrl.startsWith('assets/')
                            ? AssetImage(promotion.imageUrl)
                            : NetworkImage(promotion.imageUrl) as ImageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay for better text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.6, 0.75, 1.0],
                      ),
                    ),
                  ),
                  // Content overlay
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Discount badge if available
                        if (promotion.discountPrice != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${(((promotion.price - (promotion.discountPrice ?? 0)) / promotion.price) * 100).round()}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        // Title
                        Text(
                          promotion.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          promotion.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Price row
                        Row(
                          children: [
                            if (promotion.discountPrice != null) ...[
                              Text(
                                currencyFormat.format(promotion.price),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currencyFormat.format(promotion.discountPrice),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ] else
                              Text(
                                currencyFormat.format(promotion.price),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const Spacer(),
                            // Validity period
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Until ${DateFormat('d MMM').format(promotion.validUntil)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              'Loading special offers...',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red[300],
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading promotions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _promotionsFuture = widget.repository.getPromotions();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_offer_outlined,
                color: Colors.blue[300],
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No promotions available',
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for exciting offers!',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
